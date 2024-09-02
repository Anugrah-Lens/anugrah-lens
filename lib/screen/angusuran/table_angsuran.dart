import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/services/add_payment_services.dart';
import 'package:anugrah_lens/services/customers_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTableAngsuran extends StatefulWidget {
  final List<Glass> glasses;
  final Customer customer;
  final String? glassId;

  const CreateTableAngsuran({
    super.key,
    required this.glassId,
    required this.glasses,
    required this.customer,
  });

  @override
  _CreateTableAngsuranState createState() => _CreateTableAngsuranState();
}

class _CreateTableAngsuranState extends State<CreateTableAngsuran> {
  List<TextEditingController> controllers = [];
  final PaymentService _paymentService = PaymentService();
  String? glassId;
  List<Map<String, dynamic>> rows = [];
  final NumberFormat currencyFormatter = NumberFormat('#,##0', 'id');
  final CostumersService _customersService = CostumersService();

  void _addRow() {
    _showAddRowDialog();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.glassId != null) {
      final glass = widget.glasses.firstWhere((g) => g.id == widget.glassId);
      // Menambahkan rows untuk installments
      if (glass.installments != null) {
        for (var installment in glass.installments!) {
          rows.add({
            'no': rows.length + 1,
            'tanggal': DateFormat('dd MMMM yyyy').format(
                DateTime.parse(installment.paidDate!)
                    .add(const Duration(hours: 7))),
            'bayar': installment.amount.toString(),
            'jumlah': installment.total.toString(),
            'sisa': installment.remaining.toString(),
            'id': installment.id,
            'isEditing': false,
          });
          controllers
              .add(TextEditingController(text: installment.amount.toString()));
        }
      }
    }
  }

  void _showAddRowDialog() {
    TextEditingController tanggalController = TextEditingController();
    TextEditingController bayarController = TextEditingController();
    // Datetime pickedDate =[]
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Pilih tanggal',
                  labelText: 'Tanggal',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  // print pickedDate
                  print(pickedDate);

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd MMMM yyyy').format(pickedDate);
                    print(formattedDate);
                    setState(() {
                      tanggalController.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bayarController,
                decoration: const InputDecoration(
                  hintText: 'Bayar',
                  labelText: 'Bayar',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Selesai'),
              onPressed: () async {
                if (bayarController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nilai pembayaran tidak boleh kosong',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                int bayar =
                    int.tryParse(bayarController.text.replaceAll(',', '')) ?? 0;

                if (bayar <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Nilai pembayaran harus lebih besar dari 0',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                String? glassId = widget.glassId;

                if (glassId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'glassId is null',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  // Tampilkan loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  // Ambil tanggal dari pickedDate
                  DateTime selectedDate =
                      DateFormat('dd MMMM yyyy').parse(tanggalController.text);
                  String paidDate = selectedDate.toUtc().toIso8601String();

// Mengirim data ke backend untuk menambahkan installment
                  Map<String, dynamic> paymentData = await _paymentService
                      .addPaymentDataAmount(bayar, glassId, paidDate);

                  if (paymentData['success']) {
                    // Segera setelah menambahkan, ambil data pelanggan dan update UI
                    CustomersModel customersModel =
                        await _customersService.fetchCustomers();
                    // Ambil data installment yang baru ditambahkan
                    final customer = customersModel.customer?.firstWhere((c) =>
                        c.glasses?.any((g) => g.id == widget.glassId) == true);

                    if (customer != null) {
                      final glass = customer.glasses
                          ?.firstWhere((g) => g.id == widget.glassId);
                      if (glass != null) {
                        setState(() {
                          rows = glass.installments
                                  ?.asMap()
                                  .entries
                                  .map((entry) {
                                int index =
                                    entry.key + 1; // +1 agar nomor mulai dari 1
                                var installment = entry.value;
                                return {
                                  'no': index.toString(),
                                  'id': installment.id,
                                  'tanggal': DateFormat('dd MMMM yyyy').format(
                                      DateTime.parse(installment.paidDate!)
                                          .add(const Duration(hours: 7))),
                                  'bayar': installment.amount.toString(),
                                  'jumlah': installment.total.toString(),
                                  'sisa': installment.remaining.toString(),
                                  'isEditing': false,
                                };
                              }).toList() ??
                              [];
                        });
                      }
                    }

                    // Menampilkan Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(paymentData['message']),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.of(context).pop(); // Tutup dialog loading
                    Navigator.of(context).pop(); // Tutup dialog add
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(paymentData['message']),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditRowDialog(int index, String? installmentId) {
    if (installmentId == null) {
      print('Error: installmentId is null');
      return;
    }
    TextEditingController tanggalController = TextEditingController(
      text: rows[index]['tanggal'].toString(),
    );
    TextEditingController bayarController = TextEditingController(
      text: rows[index]['bayar'].toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Pembayaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Pilih tanggal',
                  labelText: 'Tanggal',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  print(pickedDate);

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd MMMM yyyy').format(pickedDate);
                    print(formattedDate);
                    setState(() {
                      tanggalController.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bayarController,
                decoration: const InputDecoration(
                  hintText: 'Bayar',
                  labelText: 'Bayar',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Selesai'),
              onPressed: () async {
                if (bayarController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Error: Nilai pembayaran tidak boleh kosong'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                int bayar =
                    int.tryParse(bayarController.text.replaceAll(',', '')) ?? 0;
                if (bayar <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Error: Nilai pembayaran harus lebih besar dari 0'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  // Ambil tanggal dari pickedDate
                  DateTime selectedDate =
                      DateFormat('dd MMMM yyyy').parse(tanggalController.text);
                  String paidDate = selectedDate.toUtc().toIso8601String();

                  String message = await _paymentService.updateInstallment(
                      installmentId, bayar, paidDate);

                  // Fetch ulang data setelah update
                  await _updateInstallmentData(index, installmentId);

                  // Menampilkan Snackbar dengan pesan dari response
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.of(context).pop(); // Tutup dialog loading
                  Navigator.of(context).pop(); // Tutup dialog edit
                } catch (e) {
                  print('Failed to save changes: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );

                  Navigator.of(context).pop(); // Tutup dialog loading
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateInstallmentData(int index, String installmentId) async {
    try {
      // Ambil data terbaru dari server
      CustomersModel customersModel = await _customersService.fetchCustomers();
      final customer = customersModel.customer?.firstWhere((c) =>
          c.glasses?.any((g) =>
              g.installments?.any((i) => i.id == installmentId) == true) ==
          true);

      if (customer != null) {
        final glass = customer.glasses?.firstWhere(
            (g) => g.installments?.any((i) => i.id == installmentId) == true);
        if (glass != null) {
          final updatedInstallment =
              glass.installments?.firstWhere((i) => i.id == installmentId);
          if (updatedInstallment != null) {
            // format tanggal
            String formattedDate = DateFormat('dd MMMM yyyy').format(
                DateTime.parse(updatedInstallment.paidDate!)
                    .add(const Duration(hours: 7)));
            setState(() {
              rows[index]['tanggal'] = formattedDate;
              // Update data di UI
              rows[index]['bayar'] = updatedInstallment.amount.toString();
              // Update total dan sisa jika ada
              rows[index]['total'] =
                  updatedInstallment.total; // Misalnya ada field total
              rows[index]['sisa'] =
                  updatedInstallment.remaining; // Misalnya ada field sisa
              rows[index]['isEditing'] = false;
            });
          }
        }
      }
    } catch (e) {
      print('Error updating installment data: $e');
      throw Exception('Error updating installment data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter = NumberFormat('#,##0', 'id');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thiyara Al-Mawaddah',
          style: FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Status Pembayaran :',
                          style: FontFamily.titleForm),
                      const SizedBox(width: 10),
                      Column(
                        children: widget.glasses
                            .map((glass) =>
                                Text(glass.paymentStatus ?? 'No status'))
                            .toList(),
                      )
                    ],
                  )),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => ColorStyle.primaryColor,
                      ),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Tanggal',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Bayar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Jumlah',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Sisa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Aksi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        rows.length,
                        (index) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  rows[index]['no'].toString(),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 80,
                                  ),
                                  child: Text(
                                    rows[index]['tanggal'].toString(),
                                  ),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 80,
                                  ),
                                  child: rows[index]['isEditing']
                                      ? TextField(
                                          controller: controllers[index],
                                          keyboardType: TextInputType.number,
                                        )
                                      : Text(
                                          currencyFormatter.format(int.parse(
                                              rows[index]['bayar'].toString())),
                                        ),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 80,
                                  ),
                                  child: Text(
                                    currencyFormatter.format(int.parse(
                                        rows[index]['jumlah'].toString())),
                                  ),
                                ),
                              ),
                              DataCell(
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 80,
                                  ),
                                  child: Text(
                                    currencyFormatter.format(int.parse(
                                        rows[index]['sisa'].toString())),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: rows[index]['isEditing']
                                      ? const Icon(Icons.save)
                                      : const Icon(Icons.edit),
                                  onPressed: () {
                                    String? installmentId = rows[index]['id'];
                                    if (installmentId == null) {
                                      print('Error: installmentId is null');
                                    } else {
                                      _showEditRowDialog(index, installmentId);
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.glasses
                      .where((glass) =>
                          glass.id == widget.glassId &&
                          glass.paymentStatus != 'Paid')
                      .map(
                        (glass) => Container(
                          decoration: const BoxDecoration(
                            color: ColorStyle.secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _addRow,
                            icon: const Icon(Icons.add,
                                color: ColorStyle.whiteColors),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

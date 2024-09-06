import 'package:anugrah_lens/models/customer_data_model.dart';
import 'package:anugrah_lens/services/add_payment_services.dart';
import 'package:anugrah_lens/services/customer_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTableAngsuran extends StatefulWidget {
  final String idCustomer;
  final String? glassId;

  const CreateTableAngsuran({
    super.key,
    required this.glassId,
    required this.idCustomer,
  });

  @override
  _CreateTableAngsuranState createState() => _CreateTableAngsuranState();
}

class _CreateTableAngsuranState extends State<CreateTableAngsuran> {
  List<TextEditingController> controllers = [];
  late Future<CustomerData> customersData;
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
    _fetchData();
  }

  Future<void> _fetchData() async {
    customersData = CostumersService().fetchCustomerById(widget.idCustomer);

    rows.sort((a, b) {
      DateTime dateA = DateFormat('dd MMMM yyyy').parse(a['tanggal']);
      DateTime dateB = DateFormat('dd MMMM yyyy').parse(b['tanggal']);
      return dateA.compareTo(dateB);
    });
  }

  Future<void> _editInstallmentDialog(BuildContext context,
      String installmentId, int currentAmount, String currentPaidDate) async {
    final TextEditingController amountController =
        TextEditingController(text: currentAmount.toString());

    // Pastikan currentPaidDate yang diterima adalah dalam format ISO 8601, lalu ubah ke format yang lebih mudah dibaca
    DateTime paidDate = DateTime.parse(currentPaidDate);
    final TextEditingController paidDateController = TextEditingController(
        text: DateFormat('dd MMMM yyyy')
            .format(paidDate)); // Format yang diinginkan

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Installment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Bayar'),
                ),
                TextField(
                  controller: paidDateController,
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

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd MMMM yyyy').format(pickedDate);
                      setState(() {
                        paidDateController.text = formattedDate;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tanggal tidak dipilih'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                final newAmount = int.tryParse(amountController.text);
                final newPaidDate = paidDateController.text;

                if (newAmount != null && newPaidDate.isNotEmpty) {
                  try {
                    // Tampilkan dialog loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    );

                    // Ambil tanggal dari paidDateController
                    DateTime selectedDate = DateFormat('dd MMMM yyyy')
                        .parse(paidDateController.text);

                    // Jika server membutuhkan format ISO, kirim dengan format ISO 8601
                    String paidDate = selectedDate.toUtc().toIso8601String();

                    // Edit installment dan dapatkan pesan dari server
                    String message = await _paymentService.editInstallment(
                      installmentId,
                      newAmount,
                      paidDate, // Format tanggal yang dikirim ke server
                    );

                    // Tutup loading dialog
                    Navigator.of(context).pop();

                    // Tampilkan SnackBar dengan pesan sukses
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      _fetchData();
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    // Tutup loading dialog
                    Navigator.of(context).pop();

                    // Tampilkan pesan error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  // Jika input tidak valid, tampilkan pesan error
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Amount dan tanggal tidak boleh kosong'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddRowDialog() {
    TextEditingController tanggalController = TextEditingController();
    TextEditingController bayarController = TextEditingController();

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

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd MMMM yyyy').format(pickedDate);
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
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Selesai'),
              onPressed: () async {
                // Validasi input
                if (tanggalController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Tanggal pembayaran tidak boleh kosong',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

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
                  var result = await _paymentService.addPaymentDataAmount(
                      bayar, glassId, paidDate);

                  // close loading dialog
                  Navigator.of(context).pop();

                  if (result['success']) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(result['message'] ?? 'Pembayaran berhasil'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      _fetchData();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Pembayaran gagal'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  // Tutup dialog setelah berhasil
                  Navigator.of(context).pop();
                } catch (e) {
                  // close loading dialog
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );

                  // close dialog
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
      body: FutureBuilder<CustomerData>(
        future: customersData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.0,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final customer = snapshot.data!.customer!;

            /// ambil data glass dari widget.glassId ///
            final glasses = customer.glasses
                    ?.where((glass) => glass.id == widget.glassId)
                    .toList() ??
                [];

            /// ambil data installment dari glasses ///
            final installment =
                glasses.expand((glass) => glass.installments ?? []).toList();

            if (installment.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('No data available')),
                    )),
              );
            }

            return Padding(
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
                              children: glasses.map((glass) {
                                return Text(
                                  glass.paymentStatus == 'Paid'
                                      ? 'Lunas'
                                      : 'Belum Lunas',
                                  style: TextStyle(
                                    color: glass.paymentStatus == 'Paid'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              }).toList(),
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
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                          child: installment.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: const Center(
                                      child:
                                          Text('No installment data available'),
                                    ),
                                  ),
                                )
                              : DataTable(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
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
                                    installment.length,
                                    (index) {
                                      if (index >= installment.length) {
                                        return const DataRow(cells: []);
                                      }
                                      final installmentData =
                                          installment[index];

                                      // Pastikan installmentData tidak null
                                      if (installmentData == null) {
                                        return const DataRow(cells: [
                                          DataCell(Text('No installment data')),
                                        ]);
                                      }

                                      return DataRow(
                                        cells: <DataCell>[
                                          DataCell(Text('${index + 1}')),
                                          DataCell(
                                            Text(
                                              DateFormat('dd MMMM yyyy').format(
                                                DateTime.parse(installmentData
                                                        .paidDate)
                                                    .toLocal(),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            /// buat currencyFormatter
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                  currencyFormatter.format(
                                                      installmentData.amount ??
                                                          0)),
                                            ),
                                          ),
                                          DataCell(
                                            /// buat currencyFormatter
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                  currencyFormatter.format(
                                                      installmentData.total ??
                                                          0)),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 80,
                                              child: Text(
                                                  // buat number formatter untuk mengubah angka ke format mata uang
                                                  currencyFormatter.format(
                                                      installmentData
                                                              .remaining ??
                                                          0)),
                                            ),
                                          ),
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                _editInstallmentDialog(
                                                  context,
                                                  installmentData
                                                      .id, // ID installment
                                                  installmentData
                                                      .amount!, // current amount
                                                  installmentData
                                                      .paidDate, // current paidDate
                                                );
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
                        children: glasses.map(
                          (glass) {
                            return glass.paymentStatus == 'Paid'
                                ? const SizedBox()
                                : Container(
                                    decoration: const BoxDecoration(
                                      color: ColorStyle.secondaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: _addRow,
                                      icon: const Icon(Icons.add,
                                          color: ColorStyle.whiteColors),
                                    ),
                                  );
                          },
                        ).toList(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

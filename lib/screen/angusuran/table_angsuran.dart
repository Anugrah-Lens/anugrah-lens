import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/services/add_payment_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/formatters_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
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
  //edit//
  List<TextEditingController> controllers = [];

  final PaymentService _paymentService =
      PaymentService(); // Initialize the service
  String? glassId;
  List<Map<String, dynamic>> rows = [];
  final NumberFormat currencyFormatter = NumberFormat('#,##0', 'id');

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

      // Parse the order date from String to DateTime
      DateTime orderDate = DateTime.parse(glass.orderDate!);

      // Calculate the remaining amount
      int total = glass.price ?? 0;
      int deposit = glass.deposit ?? 0;
      int remaining = total - deposit;

      // Add the first row with deposit and order date
      rows.add({
        'no': 1,
        'tanggal':
            DateFormat('dd MMMM yyyy').format(orderDate), // Tanggal pemesanan
        'bayar': deposit.toString(), // Deposit yang telah dibayarkan
        'jumlah': total.toString(), // Total price
        'sisa': remaining.toString(), // Remaining amount after deposit
        'isEditing': false,
      });
      controllers.add(TextEditingController(text: deposit.toString()));

      // Menambahkan rows untuk installments
      if (glass.installments != null) {
        for (var installment in glass.installments!) {
          rows.add({
            'no': rows.length + 1,
            'tanggal': DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(installment.paidDate!)),
            'bayar': installment.amount.toString(),
            'jumlah': installment.total.toString(),
            'sisa': installment.remaining.toString(),
            'id': installment.id, // Add installmentId here
            'isEditing': false,
          });
          controllers
              .add(TextEditingController(text: installment.amount.toString()));
        }
      }
    }
  }

  void _showAddRowDialog() {
    // Controller untuk input
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Selesai'),
              onPressed: () async {
                if (bayarController.text.isEmpty) {
                  print('Error: Nilai pembayaran tidak boleh kosong');
                  return;
                }

                int bayar =
                    int.tryParse(bayarController.text.replaceAll(',', '')) ?? 0;

                if (bayar <= 0) {
                  print('Error: Nilai pembayaran harus lebih besar dari 0');
                  return;
                }

                String? glassId = widget.glassId;

                if (glassId == null) {
                  print('Error: glassId is null');
                  return;
                }

                Map<String, dynamic>? paymentData = await _paymentService
                    .fetchPaymentDataFromBackend(bayar, glassId);

                if (paymentData == null) {
                  print('Error: Payment data is null');
                  return;
                }

                setState(() {
                  rows.add({
                    'no': rows.length + 1,
                    'tanggal': tanggalController.text,
                    'bayar': bayarController.text,
                    'jumlah': paymentData['total'].toString(),
                    'sisa': paymentData['remaining'].toString(),
                    'isEditing': false,
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//// dave button ////
  void _saveRow(int index, installmentId) async {
  
    // Validate row data
    if (rows[index]['bayar'] == null || rows[index]['id'] == null) {
      print('Error: Data for bayar or id is null');
      return;
    }

    String bayarStr = rows[index]['bayar'].toString();

    try {
      // Convert bayarStr to int
      int bayar = int.tryParse(bayarStr) ?? 0;
      // Update the installment
      await _paymentService.updateInstallment(rows[index]['id'], bayar);
      print("Data successfully updated to backend");
    } catch (e) {
      print("Failed to update data: $e");
    }
  }

  //edit ///

  // void _editRow(int index) {
  //   print("Edit row at index $index");
  //   setState(() {
  //     rows[index]['isEditing'] = true;
  //   });
  // }

  void _showEditRowDialog(int index, installmentId) {
    if (installmentId == null) {
      print('Error: installmentId is null');
      return;
    }
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
                controller: bayarController,
                decoration: const InputDecoration(
                  hintText: 'Jumlah Bayar',
                  labelText: 'Jumlah Bayar',
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
                print("Save button pressed");

                if (bayarController.text.isEmpty) {
                  print('Error: Nilai pembayaran tidak boleh kosong');
                  return;
                }

                int bayar =
                    int.tryParse(bayarController.text.replaceAll(',', '')) ?? 0;
                print("Parsed payment value: $bayar");

                if (bayar <= 0) {
                  print('Error: Nilai pembayaran harus lebih besar dari 0');
                  return;
                }

                try {
                  print(
                      'Calling updateInstallment with ID: $installmentId and payment: $bayar');
                  await _paymentService.updateInstallment(installmentId, bayar);
                  print('updateInstallment successful');

                  setState(() {
                    rows[index]['bayar'] = bayarController.text;
                    rows[index]['isEditing'] = false;
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Failed to save changes: $e');
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
                          print('Row index: $index');
                          print('Row data: ${rows[index]}');
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
                                    if (rows[index]['isEditing']) {
                                      _saveRow(index, rows[index]['id']);
                                    } else {
                                      String? installmentId = rows[index]['id'];
                                      if (installmentId == null) {
                                        print('Error: installmentId is null');
                                      } else {
                                        _showEditRowDialog(
                                            index, installmentId);
                                      }
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

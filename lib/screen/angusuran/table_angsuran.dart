import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/formatters_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTableAngsuran extends StatefulWidget {
  @override
  _CreateTableAngsuranState createState() => _CreateTableAngsuranState();
}

class _CreateTableAngsuranState extends State<CreateTableAngsuran> {
  List<Map<String, dynamic>> rows = [];

  void _addRow() {
    setState(() {
      rows.add({
        'no': rows.length + 1,
        'tanggal': '',
        'bayar': '',
        'jumlah': '',
        'sisa': '',
        'isEditing': true, // Set mode to editing for new row
      });
    });
  }

  void _saveRow(int index) {
    setState(() {
      rows[index]['isEditing'] = false;
    });
  }

  void _editRow(int index) {
    setState(() {
      rows[index]['isEditing'] = true;
    });
  }

  void _removeRow() {
    if (rows.isNotEmpty) {
      setState(() {
        rows.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thiyara Al-Mawaddah',
          style: FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
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
                      Text(
                        'Lunas',
                        style:
                            FontFamily.titleForm.copyWith(color: Colors.green),
                      ),
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
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                rows[index]['no'].toString(),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                ),
                                child: Text(
                                  rows[index]['tanggal'].toString(),
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                ),
                                child: Text(
                                  rows[index]['bayar'].toString(),
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                ),
                                child: Text(
                                  rows[index]['jumlah'].toString(),
                                ),
                              ),
                            ),
                            DataCell(
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                ),
                                child: Text(
                                  rows[index]['sisa'].toString(),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: rows[index]['isEditing']
                                    ? const Icon(Icons.save)
                                    : const Icon(Icons.edit),
                                onPressed: () => rows[index]['isEditing']
                                    ? _saveRow(index)
                                    : _editRow(index),
                              ),
                            ),
                          ],
                        ),
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
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: ColorStyle.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _showAddRowDialog,
                        icon: const Icon(Icons.add,
                            color: ColorStyle.whiteColors),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRowDialog() {
    TextEditingController tanggalController = TextEditingController();
    TextEditingController bayarController = TextEditingController();
    TextEditingController jumlahController = TextEditingController();
    TextEditingController sisaController = TextEditingController();

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
                readOnly: true, // To prevent manual editing
                decoration: const InputDecoration(
                  hintText: 'Pilih tanggal',
                  labelText: 'Tanggal',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000), // Earliest selectable date
                    lastDate: DateTime(2101), // Latest selectable date
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
              TextFieldColumnWiget(
                hintText: 'Bayar',
                controller: bayarController,
                inputFormatters: [NumberInputFormatter()],
                onChanged: (value) {
                  bayarController.text = value;
                },
              ),
              // TextField(
              //   controller: bayarController,
              //   decoration: InputDecoration(
              //     hintText: 'Masukan nominal pembayaran',
              //     labelText: 'Bayar',
              //   ),
              //   keyboardType: TextInputType.number,
              // ),
              const SizedBox(height: 10),
              TextFieldColumnWiget(
                hintText: 'Jumlah',
                controller: jumlahController,
                inputFormatters: [NumberInputFormatter()],
                onChanged: (value) {
                  jumlahController.text = value;
                },
              ),
              const SizedBox(height: 10),
              TextFieldColumnWiget(
                hintText: 'Sisa',
                controller: sisaController,
                inputFormatters: [NumberInputFormatter()],
                onChanged: (value) {
                  sisaController.text = value;
                },
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
              onPressed: () {
                setState(() {
                  rows.add({
                    'no': rows.length + 1,
                    'tanggal': tanggalController.text,
                    'bayar': bayarController.text,
                    'jumlah': jumlahController.text,
                    'sisa': sisaController.text,
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
}

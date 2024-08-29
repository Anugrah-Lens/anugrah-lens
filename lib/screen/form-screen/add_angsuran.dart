// import 'package:anugrah_lens/style/color_style.dart';
// import 'package:anugrah_lens/style/font_style.dart';
// import 'package:anugrah_lens/widget/formatters_widget.dart';
// import 'package:anugrah_lens/widget/textfield_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CreateTableAngsuran extends StatefulWidget {
//   @override
//   _CreateTableAngsuranState createState() => _CreateTableAngsuranState();
// }

// class _CreateTableAngsuranState extends State<CreateTableAngsuran> {
//   List<Map<String, dynamic>> rows = [];

//   void _addRow() {
//     setState(() {
//       rows.add({
//         'no': rows.length + 1,
//         'tanggal': '',
//         'bayar': '',
//         'jumlah': '',
//         'sisa': '',
//         'isEditing': true, // Set mode to editing for new row
//       });
//     });
//   }

//   void _saveRow(int index) {
//     setState(() {
//       rows[index]['isEditing'] = false;
//     });
//   }

//   void _editRow(int index) {
//     setState(() {
//       rows[index]['isEditing'] = true;
//     });
//   }

//   void _removeRow() {
//     if (rows.isNotEmpty) {
//       setState(() {
//         rows.removeLast();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Thiyara Al-Mawaddah',
//           style: FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                         minWidth: MediaQuery.of(context).size.width),
//                     child: DataTable(
//                       headingRowColor: MaterialStateColor.resolveWith(
//                         (states) => ColorStyle.primaryColor,
//                       ),
//                       columns: const <DataColumn>[
//                         DataColumn(
//                           label: Text(
//                             'No',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Tanggal',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Bayar',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Jumlah',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Sisa',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         DataColumn(
//                           label: Text(
//                             'Aksi',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                       rows: List<DataRow>.generate(
//                         rows.length,
//                         (index) => DataRow(
//                           cells: [
//                             DataCell(Text('${rows[index]['no']}')),
//                             DataCell(Text(rows[index]['tanggal'])),
//                             DataCell(Text(rows[index]['bayar'])),
//                             DataCell(Text(rows[index]['jumlah'])),
//                             DataCell(Text(rows[index]['sisa'])),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   minWidth: 80,
//                                 ),
//                                 child: rows[index]['isEditing']
//                                     ? TextField(
//                                         controller: TextEditingController(
//                                             text: rows[index]['tanggal']),
//                                         onTap: () async {
//                                           DateTime? pickedDate =
//                                               await showDatePicker(
//                                             context: context,
//                                             initialDate: DateTime.now(),
//                                             firstDate: DateTime(
//                                                 2000), // tanggal paling awal yang bisa dipilih
//                                             lastDate: DateTime(
//                                                 2101), // tanggal paling akhir yang bisa dipilih
//                                           );

//                                           if (pickedDate != null) {
//                                             //date formatnya 27 februari 2022
//                                             String formattedDate =
//                                                 DateFormat('dd MMMM yyyy')
//                                                     .format(pickedDate);
//                                             setState(() {
//                                               rows[index]['tanggal'] =
//                                                   formattedDate;
//                                             });
//                                           }
//                                         },
//                                         readOnly:
//                                             true, // agar keyboard tidak muncul saat field ditekan
//                                         decoration: const InputDecoration(
//                                             hintText: 'Tanggal'),
//                                       )
//                                     : Text(rows[index]['tanggal']),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: const BoxConstraints(
//                                   minWidth: 80,
//                                 ),
//                                 child: rows[index]['isEditing']
//                                     ? TextFieldColumnWiget(
//                                         inputFormatters: [
//                                           NumberInputFormatter()
//                                         ],
//                                         hintText: 'Bayar',
//                                         controller: TextEditingController(
//                                             text: rows[index]['bayar']),
//                                         onChanged: (value) {
//                                           rows[index]['bayar'] = value;
//                                         },
//                                       )
//                                     : Text(rows[index]['bayar']),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: const BoxConstraints(
//                                   minWidth: 80,
//                                 ),
//                                 child: rows[index]['isEditing']
//                                     ? TextFieldColumnWiget(
//                                         inputFormatters: [
//                                           NumberInputFormatter()
//                                         ],
//                                         onChanged: (value) {
//                                           rows[index]['jumlah'] = value;
//                                         },
//                                         hintText: 'Jumlah',
//                                         controller: TextEditingController(
//                                             text: rows[index]['jumlah']),
//                                       )
//                                     : Text(rows[index]['jumlah']),
//                               ),
//                             ),
//                             DataCell(
//                               ConstrainedBox(
//                                 constraints: const BoxConstraints(
//                                   minWidth: 80,
//                                 ),
//                                 child: rows[index]['isEditing']
//                                     ? TextFieldColumnWiget(
//                                         inputFormatters: [
//                                           NumberInputFormatter()
//                                         ],
//                                         onChanged: (value) {
//                                           rows[index]['sisa'] = value;
//                                         },
//                                         hintText: 'Sisa',
//                                         controller: TextEditingController(
//                                             text: rows[index]['sisa']),
//                                       )
//                                     : Text(rows[index]['sisa']),
//                               ),
//                             ),
//                             DataCell(
//                               rows[index]['isEditing']
//                                   ? IconButton(
//                                       icon: const Icon(Icons.save),
//                                       onPressed: () => _saveRow(index),
//                                     )
//                                   : IconButton(
//                                       icon: const Icon(Icons.edit),
//                                       onPressed: () => _editRow(index),
//                                     ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       // buat decoartinya itu circle dengan backround color primary
//                       decoration: const BoxDecoration(
//                         color: ColorStyle.secondaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: _addRow,
//                         icon: const Icon(Icons.add,
//                             color: ColorStyle.whiteColors),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Container(
//                       decoration: const BoxDecoration(
//                         color: ColorStyle.secondaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: _removeRow,
//                         icon: const Icon(Icons.remove,
//                             color: ColorStyle.whiteColors),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddRowDialog() {
//     TextEditingController bayarController = TextEditingController();
//     TextEditingController jumlahController = TextEditingController();
//     TextEditingController sisaController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Pembayaran'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: bayarController,
//                 decoration: InputDecoration(
//                   hintText: 'Masukan nominal pembayaran',
//                   labelText: 'Bayar',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: jumlahController,
//                 decoration: InputDecoration(
//                   hintText: 'Masukan jumlah',
//                   labelText: 'Jumlah',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 10),
//               TextField(
//                 controller: sisaController,
//                 decoration: InputDecoration(
//                   hintText: 'Masukan sisa',
//                   labelText: 'Sisa',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text('Batal'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Selesai'),
//               onPressed: () {
//                 setState(() {
//                   rows.add({
//                     'no': rows.length + 1,
//                     'tanggal':
//                         DateFormat('dd MMMM yyyy').format(DateTime.now()),
//                     'bayar': bayarController.text,
//                     'jumlah': jumlahController.text,
//                     'sisa': sisaController.text,
//                     'isEditing': false,
//                   });
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//     void _showAddRowDialog() {
//       TextEditingController bayarController = TextEditingController();
//       TextEditingController jumlahController = TextEditingController();
//       TextEditingController sisaController = TextEditingController();

//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Pembayaran'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: bayarController,
//                   decoration: InputDecoration(
//                     hintText: 'Masukan nominal pembayaran',
//                     labelText: 'Bayar',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: jumlahController,
//                   decoration: InputDecoration(
//                     hintText: 'Masukan jumlah',
//                     labelText: 'Jumlah',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: sisaController,
//                   decoration: InputDecoration(
//                     hintText: 'Masukan sisa',
//                     labelText: 'Sisa',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: Text('Batal'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text('Selesai'),
//                 onPressed: () {
//                   setState(() {
//                     rows.add({
//                       'no': rows.length + 1,
//                       'tanggal':
//                           DateFormat('dd MMMM yyyy').format(DateTime.now()),
//                       'bayar': bayarController.text,
//                       'jumlah': jumlahController.text,
//                       'sisa': sisaController.text,
//                       'isEditing': false,
//                     });
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }

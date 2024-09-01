import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/table_angsuran.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/text_widget.dart';
import 'package:flutter/material.dart';

class DetailAngsuranSCreen extends StatefulWidget {
  final Customer customer;
  final List<Glass> glass;
  final String idCustomer;
  final String idGlass;

  DetailAngsuranSCreen({
    Key? key,
    required this.glass,
    required this.idCustomer,
    required this.idGlass,
    required this.customer,
  }) : super(key: key);

  @override
  State<DetailAngsuranSCreen> createState() => _DetailAngsuranSCreenState();
}

class _DetailAngsuranSCreenState extends State<DetailAngsuranSCreen> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelanggan Baru',
          style: FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleTextWIdget(name: 'Nama Pelanggan'),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        customer.name.toString(),
                        style: FontFamily.caption,
                      ),
                    ),
                    const TitleTextWIdget(name: 'Alamat'),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        customer.address.toString(),
                        style: FontFamily.caption,
                      ),
                    ),
                    const TitleTextWIdget(name: 'No Telepon'),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        customer.phone.toString(),
                        style: FontFamily.caption,
                      ),
                    ),
                    if (_isExpanded &&
                        customer.glasses?.isNotEmpty == true) ...[
                      const SizedBox(height: 20.0),
                      const TitleTextWIdget(name: 'Nama Gagang(Frame)'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.frame ?? 'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Jenis Kaca'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.lensType ?? 'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Ukuran'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Left : ${customer.glasses!.first.left ?? 'Tidak tersedia'}',
                            style: FontFamily.caption,
                          ),
                          Text(
                            'Right : ${customer.glasses!.first.right ?? 'Tidak tersedia'}',
                            style: FontFamily.caption,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const TitleTextWIdget(name: 'Tanggal Pemesanan'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.orderDate ?? 'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const TitleTextWIdget(name: 'Tanggal Pengantaran'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.deliveryDate ??
                              'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Harga'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.price?.toString() ??
                              'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Deposit(DP)'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          customer.glasses!.first.deposit?.toString() ??
                              'Tidak tersedia',
                          style: FontFamily.caption,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Sisa Pembayaran: ${customer.glasses!.first.price! - customer.glasses!.first.deposit!}',
                          style: FontFamily.caption
                              .copyWith(color: ColorStyle.errorColor),
                        ),
                      ),
                    ],
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: _toggleExpansion,
                    child: Text(
                      _isExpanded
                          ? 'Lihat lebih sedikit'
                          : 'Lihat selengkapnya',
                      style: FontFamily.titleForm
                          .copyWith(color: ColorStyle.secondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Metode Pembayaran',
                    style: FontFamily.title.copyWith(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer.glasses!.first.paymentMethod ??
                            'Tidak tersedia',
                        style: FontFamily.titleForm.copyWith(
                          color: ColorStyle.textColors,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        customer.glasses!.first.paymentStatus == 'Paid'
                            ? 'Lunas'
                            : 'Belum Lunas',
                        style: FontFamily.titleForm.copyWith(
                          color: customer.glasses!.first.paymentStatus == 'Paid'
                              ? ColorStyle.successColor
                              : ColorStyle.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButtonWidget(
                  color: ColorStyle.primaryColor,
                  text: 'Lihat Pembayaran',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTableAngsuran(
                          customer: customer,
                          glasses: widget.glass,
                          glassId: widget.idGlass,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


// // Widget AlertDialog terpisah, ditempatkan di bawah
// class PaymentConfirmationDialog extends StatelessWidget {
//   final VoidCallback onConfirmed;

//   PaymentConfirmationDialog({required this.onConfirmed});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       title: const Center(
//         child: Text('Konfirmasi Pembayaran', style: FontFamily.title),
//       ),
//       content: const Text(
//         textAlign: TextAlign.center,
//         'Apakah pembayaran kaca mata telah dilunasi secara cash?',
//         style: FontFamily.caption,
//       ),
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//               child: const Text('Belum'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.black, // Warna teks
//                 side: const BorderSide(
//                   color: Colors.black, // Warna border
//                   width: 1.5, // Lebar border
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 onConfirmed(); // Memanggil callback ketika tombol "Lunas" ditekan
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor:
//                     ColorStyle.primaryColor, // Warna latar belakang
//                 foregroundColor: ColorStyle.whiteColors, // Warna teks
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: Text('Lunas',
//                   style: FontFamily.caption
//                       .copyWith(color: ColorStyle.whiteColors)),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// /// dialoh cancel /////

// class CancelConfirmationDialog extends StatelessWidget {
//   final VoidCallback onCancelConfirmed;

//   const CancelConfirmationDialog({Key? key, required this.onCancelConfirmed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       title: const Center(
//         child: Text('Batalkan Konfrimasi', style: FontFamily.title),
//       ),
//       content: const Text(
//         textAlign: TextAlign.center,
//         'Apakah Anda yakin ingin membatalkan Konfirmasi ini ?',
//         style: FontFamily.caption,
//       ),
//       actions: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//               child: const Text('Tidak'),
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.black, // Warna teks
//                 side: const BorderSide(
//                   color: Colors.black, // Warna border
//                   width: 1.5, // Lebar border
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 onCancelConfirmed(); // Memanggil callback ketika tombol "Lunas" ditekan
//                 Navigator.of(context).pop(); // Menutup dialog
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor:
//                     ColorStyle.primaryColor, // Warna latar belakang
//                 foregroundColor: ColorStyle.whiteColors, // Warna teks
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: Text('Ya',
//                   style: FontFamily.caption
//                       .copyWith(color: ColorStyle.whiteColors)),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

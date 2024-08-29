import 'package:anugrah_lens/screen/angusuran/table_angsuran.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/text_widget.dart';
import 'package:flutter/material.dart';

class DetailAngsuranSCreen extends StatefulWidget {
  final String name;
  final String address;
  final int phone;
  final String frameName;
  final String lensType;
  final String leftSize;
  final String rightSize;
  final String orderDate;
  final String deliveryDate;
  final int price;
  final int deposit;
  final String paymentMethod;

  DetailAngsuranSCreen(
      {Key? key,
      required this.name,
      required this.address,
      required this.phone,
      required this.frameName,
      required this.lensType,
      required this.leftSize,
      required this.rightSize,
      required this.orderDate,
      required this.deliveryDate,
      required this.price,
      required this.deposit,
      required this.paymentMethod})
      : super(key: key);

  @override
  State<DetailAngsuranSCreen> createState() => _DetailAngsuranSCreenState();
}

class _DetailAngsuranSCreenState extends State<DetailAngsuranSCreen> {
  @override
  // bool isPaymentConfirmed = false;
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final remainingPayment = int.parse(widget.price.toString()) -
        int.parse(widget.deposit.toString());
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
                        widget.name,
                        style: FontFamily.caption,
                      ),
                    ),
                    const TitleTextWIdget(name: 'Alamat'),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        widget.address,
                        style: FontFamily.caption,
                      ),
                    ),
                    const TitleTextWIdget(name: 'No Telepon'),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        widget.phone.toString(),
                        style: FontFamily.caption,
                      ),
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(
                        height: 20.0,
                      ),
                      const TitleTextWIdget(name: 'Nama Gagang(Frame)'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          widget.frameName,
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Jenis Kaca'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          widget.lensType,
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Ukuran'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Left : ${widget.leftSize}',
                              style: FontFamily.caption),
                          Text('Right : ${widget.rightSize}',
                              style: FontFamily.caption),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const TitleTextWIdget(name: 'Tanggal Pemesanan'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child:
                            Text(widget.orderDate, style: FontFamily.caption),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const TitleTextWIdget(name: 'Tanggal Pengantaran'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(widget.deliveryDate,
                            style: FontFamily.caption),
                      ),
                      const TitleTextWIdget(name: 'Harga'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          widget.price.toString(),
                          style: FontFamily.caption,
                        ),
                      ),
                      const TitleTextWIdget(name: 'Deposit(DP)'),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          widget.deposit.toString(),
                          style: FontFamily.caption,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                            'Sisa Pembayaran: $remainingPayment',
                            style: FontFamily.caption
                                .copyWith(color: ColorStyle.errorColor)),
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
                            .copyWith(color: ColorStyle.secondaryColor)),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Metode Pembayaran',
                    style: FontFamily.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.paymentMethod,
                        style: FontFamily.caption,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        /// kalau paymentMethod == 'Lunas' maka warna text menjadi hijau
                        widget.paymentMethod == 'Lunas'
                            ? 'Lunas'
                            : 'Belum Lunas',
                        style: FontFamily.titleForm.copyWith(
                            color: widget.paymentMethod == 'Lunas'
                                ? ColorStyle.successColor
                                : ColorStyle.errorColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                // buat apabila sudah lunas maka warna button menajadi disabled
                ElevatedButtonWidget(
                  color: ColorStyle.primaryColor,
                  text: 'Lihat Pembayaran',
                  onPressed: () {
                    //navgate to TableAngsuran
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTableAngsuran(),
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

// Widget AlertDialog terpisah, ditempatkan di bawah
class PaymentConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmed;

  PaymentConfirmationDialog({required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      title: const Center(
        child: Text('Konfirmasi Pembayaran', style: FontFamily.title),
      ),
      content: const Text(
        textAlign: TextAlign.center,
        'Apakah pembayaran kaca mata telah dilunasi secara cash?',
        style: FontFamily.caption,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Belum'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Warna teks
                side: const BorderSide(
                  color: Colors.black, // Warna border
                  width: 1.5, // Lebar border
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            TextButton(
              onPressed: () {
                onConfirmed(); // Memanggil callback ketika tombol "Lunas" ditekan
                Navigator.of(context).pop(); // Menutup dialog
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    ColorStyle.primaryColor, // Warna latar belakang
                foregroundColor: ColorStyle.whiteColors, // Warna teks
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('Lunas',
                  style: FontFamily.caption
                      .copyWith(color: ColorStyle.whiteColors)),
            ),
          ],
        ),
      ],
    );
  }
}

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

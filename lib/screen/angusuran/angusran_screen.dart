import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:flutter/material.dart';

class AngsuranScreen extends StatefulWidget {
  AngsuranScreen({Key? key}) : super(key: key);

  @override
  State<AngsuranScreen> createState() => _AngsuranScreenState();
}

class _AngsuranScreenState extends State<AngsuranScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        CardAnsuranWidget(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailAngsuranSCreen(
                      address: 'Jl. Jendral Sudirman No. 1',
                      deliveryDate: '17 Februari 2021',
                      deposit: 100000,
                      frameName: 'Bulletproof',
                      leftSize: '1.5',
                      rightSize: '1.5',
                      lensType: 'Photochromic',
                      name: 'Thierry Henry',
                      orderDate: '17 Februari 2021',
                      paymentMethod: 'Cash',
                      price: 1000000,
                      phone: 081234567890),
                ));
          },
          label: 'Angsuran',
          address: 'Jl. Jendral Sudirman No. 1',
          sisaPembayaran: 'Sisa Pembayaran : Rp. 900.000',
          frameName: 'Action',
          glassesName: 'Gentel Monster',
          decoration: BoxDecoration(
            color: ColorStyle.secondaryColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
        )
      ],
    ));
  }
}

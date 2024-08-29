import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:flutter/material.dart';

class SelesaiScreen extends StatefulWidget {
  SelesaiScreen({Key? key}) : super(key: key);

  @override
  State<SelesaiScreen> createState() => _SelesaiScreenState();
}

class _SelesaiScreenState extends State<SelesaiScreen> {
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
          label: 'Selesai',
          address: 'Jl. Jendral Sudirman No. 1',
          sisaPembayaran: 'Sisa Pembayaran : -',
          frameName: 'Action',
          glassesName: 'Gentel Monster',
          decoration: BoxDecoration(
            color: ColorStyle.successColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
        )
      ],
    ));
  }
}

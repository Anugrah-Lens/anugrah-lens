import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:flutter/material.dart';

class SelesaiScreen extends StatefulWidget {
  final Customer customer; // Object to represent the customer
  final List<Glass> glass; // List of Glass objects associated with the customer
  final String idCustomer;
  final String idGlass;
  SelesaiScreen(
      {Key? key,
      required this.customer,
      required this.idCustomer,
      required this.idGlass,
      required this.glass})
      : super(key: key);

  @override
  State<SelesaiScreen> createState() => _SelesaiScreenState();
}

class _SelesaiScreenState extends State<SelesaiScreen> {
  @override
  Widget build(BuildContext context) {
    final customer = widget.customer; // Akses data customer
    final glass = customer.glasses?.isNotEmpty == true
        ? customer.glasses!.first
        : null; // Ambil data kaca mata pertama jika ada

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (glass != null) // Ensure glass is not null before displaying
            CardAnsuranWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailAngsuranSCreen(
                      idCustomer: widget.idCustomer,
                      idGlass: widget.idGlass,

                      customer: customer,
                      glass: widget.glass, // Passing the list of Glass objects
                    ),
                  ),
                );
              },
              label: glass.paymentMethod ?? 'Metode pembayaran tidak tersedia',
              address: customer.address ?? 'Alamat tidak tersedia',
              sisaPembayaran:
                  'Sisa Pembayaran : Rp. ${glass.price != null && glass.deposit != null ? glass.price! - glass.deposit! : 0}',
              frameName: glass.frame ?? 'Nama frame tidak tersedia',
              glassesName: glass.lensType ?? 'Tipe lensa tidak tersedia',
              decoration: BoxDecoration(
                color: ColorStyle.secondaryColor,
                borderRadius: BorderRadius.circular(4.0),
              ),
            )
          else
            Center(child: Text('Data kaca mata tidak tersedia')),
        ],
      ),
    );
  }
}

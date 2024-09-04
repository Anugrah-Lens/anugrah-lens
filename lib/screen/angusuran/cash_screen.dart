import 'package:anugrah_lens/models/customersGlasses_model.dart';
import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:flutter/material.dart';

class CashScreen extends StatefulWidget {
  final Customer customer; // Object to represent the customer
  final List<Glass> glass; // List of Glass objects associated with the customer
  final String idCustomer;

  CashScreen({
    Key? key,
    required this.customer,
    required this.idCustomer,

    required this.glass,
  }) : super(key: key);

  @override
  State<CashScreen> createState() => _CashScreenState();
}

class _CashScreenState extends State<CashScreen> {
  @override
  Widget build(BuildContext context) {
    final customer = widget.customer; // Akses data customer

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Iterate over the list of glasses and display a card for each
          ...widget.glass.map((glass) {
            return CardAnsuranWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailAngsuranSCreen(
                      idCustomer: widget.idCustomer,
                      idGlass: glass.id ?? '',
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
            );
          }).toList(),
        ],
      ),
    );
  }
}

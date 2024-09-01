import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/angusran_screen.dart';
import 'package:anugrah_lens/screen/angusuran/cash_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/floating_action_button_widget.dart';
import 'package:flutter/material.dart';

import 'selesai_screen.dart';

class MenuAngsuranScreen extends StatefulWidget {
  final Customer customersModel;
  final String idCustomer;
  final String idGlass;

  MenuAngsuranScreen(
      {Key? key,
      required this.customersModel,
      required this.idGlass,
      required this.idCustomer})
      : super(key: key);

  @override
  State<MenuAngsuranScreen> createState() => _MenuAngsuranScreenState();
}

class _MenuAngsuranScreenState extends State<MenuAngsuranScreen> {
  bool isAngsuranActive = true;
  bool isCashActive = false;
  bool isSelesaiActive = false;

  void changeMenu(String classMenu) {
    setState(() {
      isAngsuranActive = classMenu == "Angsuran";
      isCashActive = classMenu == "Cash";
      isSelesaiActive = classMenu == "Selesai";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thiyara Al-Mawaddah", style: FontFamily.title),
      ),
      body: ListView(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isAngsuranActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          changeMenu("Angsuran");
                        },
                        child: Text(
                          "Angsuran",
                          style: FontFamily.caption.copyWith(
                            fontSize: 14,
                            color: isAngsuranActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor.withOpacity(
                                    0.6), // Warna teks jika tidak aktif
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isCashActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          changeMenu("Cash");
                        },
                        child: Text(
                          "Cash",
                          style: FontFamily.caption.copyWith(
                            fontSize: 14,
                            color: isCashActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor.withOpacity(
                                    0.6), // Warna teks jika tidak aktif
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelesaiActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          changeMenu("Selesai");
                        },
                        child: Text(
                          "Selesai",
                          style: FontFamily.caption.copyWith(
                            fontSize: 14,
                            color: isSelesaiActive
                                ? ColorStyle.primaryColor
                                : ColorStyle.disableColor.withOpacity(
                                    0.6), // Warna teks jika tidak aktif
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          isAngsuranActive
              ? AngsuranScreen(
                  idCustomer: widget.idCustomer,
                  idGlass: widget.idGlass,
                  glass: widget.customersModel.glasses!,
                  //// masi salaah harusnya bukan first
                  customer: widget.customersModel)
              : isCashActive
                  ? CashScreen(
                      idCustomer: widget.idCustomer,
                      idGlass: widget.idGlass,
                      glass: widget.customersModel.glasses!,
                      //// masi salaah harusnya bukan first
                      customer: widget.customersModel)
                  : SelesaiScreen(
                      idCustomer: widget.idCustomer,
                      idGlass: widget.idGlass,
                      glass: widget.customersModel.glasses!,
                      //// masi salaah harusnya bukan first
                      customer: widget.customersModel),
        ],
      ),
      // floatingActionButton: CustomFloatingActionButton(
      //   onPressed: () {
      //     // Tambahkan fungsionalitas yang diinginkan di sini
      //   },
      //   icon: Icons.add,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

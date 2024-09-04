// ignore_for_file: unnecessary_null_comparison

import 'package:anugrah_lens/models/customersGlasses_model.dart';
import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/angusran_screen.dart';
import 'package:anugrah_lens/screen/angusuran/cash_screen.dart';
import 'package:anugrah_lens/services/customers_services.dart';
import 'package:anugrah_lens/services/customersbyid_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:flutter/material.dart';

import 'selesai_screen.dart';

class MenuAngsuranScreen extends StatefulWidget {
  final Customer customersModel;
  final String idCustomer;
  final String idGlass;
  final List<Glass> glass;

  MenuAngsuranScreen({
    Key? key,
    required this.customersModel,
    required this.idGlass,
    required this.idCustomer,
    required this.glass,
  }) : super(key: key);

  @override
  State<MenuAngsuranScreen> createState() => _MenuAngsuranScreenState();
}

class _MenuAngsuranScreenState extends State<MenuAngsuranScreen> {
  late Future<CustomersModel> customersData;

  bool isAngsuranActive = false;
  bool isCashActive = false;
  bool isSelesaiActive = false;

  void determineInitialMenu() {
    // Ambil glass yang sesuai dengan idGlass
    final Glass selectedGlass = widget.glass.firstWhere(
      (glass) => glass.id == widget.idGlass,
      orElse: () => Glass(),
    );

    // Periksa paymentMethod dan paymentStatus langsung dari selectedGlass
    if (selectedGlass.paymentStatus == "Paid") {
      isSelesaiActive = true;
      isAngsuranActive = false;
      isCashActive = false;
    } else if (selectedGlass.paymentMethod == "Installment") {
      isAngsuranActive = true;
      isCashActive = false;
      isCashActive = false;
    } else if (selectedGlass.paymentMethod == "Cash") {
      isCashActive = true;
      isAngsuranActive = false;
      isSelesaiActive = false;
    }
  }

  void changeMenu(String classMenu) {
    setState(() {
      isAngsuranActive = classMenu == "Angsuran";
      isCashActive = classMenu == "Cash";
      isSelesaiActive = classMenu == "Selesai";
    });
  }

  @override
  void initState() {
    super.initState();
    customersData = CostumersService().fetchCustomers();
    determineInitialMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pelanggan", style: FontFamily.title),
      ),
      body: FutureBuilder<CustomersModel>(
        future: customersData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.0,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final customer = snapshot.data!.customer!;
            final Glass selectedGlass = widget.glass.firstWhere(
              (glass) => glass.id == widget.idGlass,
              orElse: () => Glass(),
            );

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildMenuButton("Angsuran", isAngsuranActive),
                      _buildMenuButton("Cash", isCashActive),
                      _buildMenuButton("Selesai", isSelesaiActive),
                    ],
                  ),
                ),
                if (isAngsuranActive)
                  AngsuranScreen(
                    idCustomer: widget.idCustomer,
                    glass: [selectedGlass],
                    customer: widget.customersModel,
                  )
                else if (isCashActive)
                  CashScreen(
                    idCustomer: widget.idCustomer,
                    glass: [selectedGlass],
                    customer: widget.customersModel,
                  )
                else if (isSelesaiActive)
                  SelesaiScreen(
                    idCustomer: widget.idCustomer,
                    glass: [selectedGlass],
                    customer: widget.customersModel,
                  ),
              ],
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }

  Widget _buildMenuButton(String menu, bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  isActive ? ColorStyle.primaryColor : ColorStyle.disableColor,
              width: 2,
            ),
          ),
        ),
        child: TextButton(
          onPressed: () {
            changeMenu(menu);
          },
          child: Text(
            menu,
            style: FontFamily.caption.copyWith(
              fontSize: 14,
              color: isActive
                  ? ColorStyle.primaryColor
                  : ColorStyle.disableColor.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

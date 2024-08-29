import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/formatters_widget.dart';
import 'package:anugrah_lens/widget/radio_button_widget.dart';
import 'package:anugrah_lens/widget/text_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:flutter/material.dart';

class CreateNewAngsuranScreen extends StatefulWidget {
  CreateNewAngsuranScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateNewAngsuranScreen> createState() =>
      _CreateNewAngsuranScreenState();
}

class _CreateNewAngsuranScreenState extends State<CreateNewAngsuranScreen> {
  final TextEditingController name = TextEditingController();
  // phone diubah dari int ke TextEditingController
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController frameName = TextEditingController();
  final TextEditingController lensType = TextEditingController();
  final TextEditingController leftSize = TextEditingController();
  final TextEditingController rightSize = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController deposit = TextEditingController();
  final TextEditingController orderDate = TextEditingController();
  final TextEditingController deliveryDate = TextEditingController();
  final TextEditingController paymentMethod = TextEditingController();

  String _paymentStatus = 'Lunas';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Pelanggan Baru',
            style:
                FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor)),
      ),
      
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleTextWIdget(
                  name: 'Nama Pelanggan',
                ),
                SearchDropdownField(
                  suffixIcons: Icon(
                    Icons.arrow_drop_down,
                    color: ColorStyle.primaryColor,
                  ),
                  controller: name,
                  hintText: 'e.g. John Doe',
                  items: [
                    'John Doe',
                    'Jane Smith',
                    'Alice Johnson',
                    'Thiyara Al-Mawaddah'
                  ],
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'No Telepon',
                ),
                TextFieldWidget(
                  controller: phone,
                  hintText: 'e.g. 08123456789',
                ),
                const SizedBox(height: 4.0),
                TitleTextWIdget(
                  name: 'Alamat',
                ),
                TextFieldWidget(
                  controller: address,
                  hintText: 'e.g. Alamat',
                ),
                const SizedBox(height: 20.0),
                const TitleTextWIdget(
                  name: 'Nama gagang (Frame)',
                ),
                TextFieldWidget(
                  controller: frameName,
                  hintText: 'e.g. duvali 883',
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'Jenis Kaca',
                ),
                TextFieldWidget(
                  controller: lensType,
                  hintText: 'e.g. Phtochromic',
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'Ukuran',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Left',
                          style: FontFamily.caption
                              .copyWith(color: ColorStyle.secondaryColor),
                        ),
                        const SizedBox(height: 4.0),
                        //buat textfield yang baru dengan ukurna kecil
                        TextFieldWidget(
                          controller: leftSize,
                          hintText: 'e.g. 50',
                          width: 100,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Right',
                          style: FontFamily.caption
                              .copyWith(color: ColorStyle.secondaryColor),
                        ),
                        const SizedBox(height: 4.0),
                        //buat textfield yang baru dengan ukurna kecil
                        TextFieldWidget(
                          controller: rightSize,
                          hintText: 'e.g. 50',
                          width: 100,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                const TitleTextWIdget(
                  name: 'Harga Kaca Mata',
                ),
                TextFieldWidget(
                  inputFormatters: [NumberInputFormatter()],
                  controller: price,
                  hintText: 'e.g. 500.000',
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'Deposit(DP)',
                ),
                TextFieldWidget(
                  inputFormatters: [NumberInputFormatter()],
                  controller: deposit,
                  hintText: 'e.g. 100.000',
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text('Sisa Pembayaran: RP 400.000',
                      style: FontFamily.caption
                          .copyWith(color: ColorStyle.errorColor)),
                ),
                const SizedBox(height: 20.0),
                const TitleTextWIdget(
                  name: 'Tanggal Pesanan',
                ),
                TextFieldCalenderWidget(
                  controller: orderDate,
                  hintText: 'e.g. 23 Februari 2022',
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'Tanggal Antaran',
                ),
                TextFieldCalenderWidget(
                  controller: deliveryDate,
                  hintText: 'e.g. 23 Februari 2022',
                ),
                const SizedBox(height: 4.0),
                const TitleTextWIdget(
                  name: 'Metode Pembayaran',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RadioButtonWidget(
                        value: 'Lunas',
                        groupValue: _paymentStatus,
                        text: 'Lunas',
                        onChanged: (String? value) {
                          setState(() {
                            _paymentStatus = value!;
                          });
                        },
                      ),
                      RadioButtonWidget(
                        value: 'Angsuran',
                        groupValue: _paymentStatus,
                        text: 'Angsuran',
                        onChanged: (String? value) {
                          setState(() {
                            _paymentStatus = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButtonWidget(
                  onPressed: () {
                    //hapus tanda koma
                    final int parsedPhone =
                        int.parse(phone.text.replaceAll(',', ''));
                    final int parsedPrice =
                        int.parse(price.text.replaceAll(',', ''));
                    final int parsedDeposit =
                        int.parse(deposit.text.replaceAll(',', ''));

                    final selectedPaymentMethod = _paymentStatus;

                    /// navigator ke halaman DetailAngsuranScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailAngsuranSCreen(
                          name: name.text,
                          phone: parsedPhone,
                          address: address.text,
                          frameName: frameName.text,
                          lensType: lensType.text,
                          leftSize: leftSize.text,
                          rightSize: rightSize.text,
                          price: parsedPrice,
                          deposit: parsedDeposit,
                          orderDate: orderDate.text,
                          deliveryDate: deliveryDate.text,
                          paymentMethod: selectedPaymentMethod,
                        ),
                      ),
                    );
                  },
                  text: 'Simpan',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

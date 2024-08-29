import 'package:anugrah_lens/screen/angusuran/menu_angsuran.dart';
import 'package:anugrah_lens/screen/form-screen/create_new_angsuran.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:anugrah_lens/widget/floating_action_button_widget.dart';
import 'package:anugrah_lens/widget/seacrh_bar_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RiwayatPageScreen extends StatefulWidget {
  RiwayatPageScreen({Key? key}) : super(key: key);

  @override
  State<RiwayatPageScreen> createState() => _RiwayatPageScreenState();
}

class _RiwayatPageScreenState extends State<RiwayatPageScreen> {
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteColors,
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColors,
        title: Text(
          'Riwayat',
          style:
              FontFamily.title.copyWith(color: ColorStyle.secondaryColor),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                SearchDropdownField(
                  prefixIcons:
                      const Icon(Icons.search, color: ColorStyle.disableColor),
                  suffixIcons: null,
                  controller: name,
                  hintText: 'cari nama pelanggan',
                  items: [
                    'John Doe',
                    'Jane Smith',
                    'Alice Johnson',
                    'Thiyara Al-Mawaddah'
                  ],
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      CardNameWidget(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuAngsuranScreen(),
                              ));
                        },
                        name: 'Thiyara Al-Mawaddah',
                      ),
                      CardNameWidget(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuAngsuranScreen(),
                              ));
                        },
                        name: 'Jeremy Lewi Munthe',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

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

class BerandaPageScreen extends StatefulWidget {
  BerandaPageScreen({Key? key}) : super(key: key);

  @override
  State<BerandaPageScreen> createState() => _BerandaPageScreenState();
}

class _BerandaPageScreenState extends State<BerandaPageScreen> {
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteColors,
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColors,
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            'Hello, thiyara',
            style:
                FontFamily.titleForm.copyWith(color: ColorStyle.primaryColor),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorStyle.primaryColor, // Adjust the color as needed
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/free-photo/business-finance-employment-female-successful-entrepreneurs-concept-confident-smiling-asian-businesswoman-office-worker-white-suit-glasses-using-laptop-help-clients_1258-59126.jpg?t=st=1724925519~exp=1724929119~hmac=c3b92a7be28ab28deebb3cd42b9755db39ca7267895a35ca60158967930094a2&w=740'), // Replace with your image URL
                  ),
                  SizedBox(width: 16), // Space between the picture and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Thiyara Al-Mawaddah',
                        style: FontFamily.titleForm.copyWith(
                            color: ColorStyle.whiteColors,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'thiyaraali@gmail.com',
                        style: FontFamily.caption.copyWith(
                            color: ColorStyle.whiteColors),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: ColorStyle.primaryColor),
              title: Text('Beranda',
                  style: FontFamily.caption
                      .copyWith(color: ColorStyle.primaryColor)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the Beranda screen
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.history, color: ColorStyle.primaryColor),
              title: Text('Riwayat',
                  style: FontFamily.caption
                      .copyWith(color: ColorStyle.primaryColor)),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the Riwayat screen
              },
            ),
            const SizedBox(
              height: 200.0,
            ),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, color: ColorStyle.primaryColor),
              title: Text('Keluar',
                  style: FontFamily.caption
                      .copyWith(color: ColorStyle.primaryColor)),
              onTap: () {
                Navigator.pop(context);
                // Add logic for logout
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text("Anugrah Lens", style: FontFamily.h3),
                ),
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
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewAngsuranScreen(),
              ));
        },
        icon: Icons.add,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

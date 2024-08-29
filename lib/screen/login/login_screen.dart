import 'package:anugrah_lens/screen/home/bottom_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/circle_background_pointer.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteColors,
      body: Center(
        
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircleBackgroundWidget(
              color: Color.fromARGB(255, 215, 228, 194), // Warna custom untuk lingkaran
              topRightRadius:
                  120.0, // Radius custom untuk lingkaran di pojok kanan atas
              bottomLeftRadius: 180.0, // Radius custom untuk lingkaran di bawah
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text('Anugrah Lensa', style: FontFamily.h2),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        ' kelola data pelanggan dengan mudah dan cepat ',
                        style: FontFamily.caption),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Image.asset('assets/images/login.png'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButtonWidget(
                      text: "Login with Google Account", onPressed: () {
                        //navigator ke firstscreen
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const FirstScreen();
                        }));
                      })
                ],
              ),
            )),
      ),
    );
  }
}

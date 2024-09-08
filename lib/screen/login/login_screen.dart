import 'package:anugrah_lens/screen/home/bottom_screen.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/circle_background_pointer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final prefs =
        await SharedPreferences.getInstance(); // Inisialisasi SharedPreferences

    if (googleUser == null) {
      // Pengguna membatalkan login
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Login ke Firebase dengan credential Google
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Simpan data pengguna ke SharedPreferences
    await prefs.setString('name', userCredential.user?.displayName ?? '');
    await prefs.setString('email', userCredential.user?.email ?? '');
    await prefs.setString('photoUrl', userCredential.user?.photoURL ?? '');
    await prefs.setString('token', userCredential.user?.refreshToken ?? '');

    // print semua
    print(userCredential.user?.displayName);

    return userCredential;
  } catch (e) {
    print('Error during Google Sign-In: $e');
    return null;
  }
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
              color: Color.fromARGB(
                  255, 215, 228, 194), // Warna custom untuk lingkaran
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
                    text: "Login with Google Account",
                    onPressed: () {
                      signInWithGoogle().then((value) {
                        if (value != null) {
                          print("Login berhasil, user: ${value.user?.email}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FirstScreen(activeScreen: 0),
                            ),
                          );
                        } else {
                          print("Login gagal");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Login gagal, silakan coba lagi.')),
                          );
                        }
                      }).catchError((error) {
                        print("Terjadi error selama login: $error");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Terjadi kesalahan selama login: $error')),
                        );
                      });
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}

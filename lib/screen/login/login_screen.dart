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
    await prefs.setString('token', userCredential.user?.uid ?? '');

    // print semua
    print(userCredential.user?.displayName);
    print(' refresh token : ${userCredential.user?.uid}');

    return userCredential;
  } catch (e) {
    print('Error during Google Sign-In: $e');
    return null;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController codeController = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    obscureText = true;
  }

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
                    child: Text('Anugrah Lens', style: FontFamily.h2),
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

                          // Tampilkan dialog untuk memasukkan kode admin
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Masukkan Kode Admin',
                                  style: FontFamily.title.copyWith(
                                    color: ColorStyle.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return TextField(
                                      controller: codeController,
                                      obscureText:
                                          obscureText, // Tampilkan karakter atau tidak
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: ColorStyle.primaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              obscureText =
                                                  !obscureText; // Toggle obscureText
                                            });
                                          },
                                        ),
                                        hintText: 'Kode Admin',
                                        hintStyle:
                                            FontFamily.titleForm.copyWith(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Batal',
                                      style: FontFamily.titleForm.copyWith(
                                        color: ColorStyle.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'OK',
                                      style: FontFamily.caption.copyWith(
                                        color: ColorStyle.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    onPressed: () {
                                      // Cek apakah kode yang dimasukkan sesuai
                                      if (codeController.text == 'Anugrah112') {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                        // Arahkan ke halaman pertama jika kode benar
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FirstScreen(
                                                    activeScreen: 0),
                                          ),
                                        );
                                      } else {
                                        // Tampilkan pesan kesalahan jika kode salah
                                        showTopSnackBar(
                                          context,
                                          'Kode admin salah, silakan coba lagi',
                                          backgroundColor:
                                              ColorStyle.errorColor,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print("Login gagal");
                          showTopSnackBar(
                            context,
                            'Login gagal, silakan coba lagi',
                            backgroundColor: ColorStyle.errorColor,
                          );
                        }
                      }).catchError((error) {
                        print("Terjadi error selama login: $error");
                        showTopSnackBar(
                          context,
                          'Terjadi error selama login, silakan coba lagi',
                          backgroundColor: ColorStyle.errorColor,
                        );
                      });
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void showTopSnackBar(
    context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        duration: duration ?? const Duration(milliseconds: 1000),
        backgroundColor: backgroundColor ?? ColorStyle.primaryColor,
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 10,
            right: 10),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: FontFamily.caption.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

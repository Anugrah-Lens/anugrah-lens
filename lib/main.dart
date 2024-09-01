import 'package:anugrah_lens/screen/angusuran/detail_angsuran_screen.dart';
import 'package:anugrah_lens/screen/angusuran/menu_angsuran.dart';
import 'package:anugrah_lens/screen/angusuran/table_angsuran.dart';
import 'package:anugrah_lens/screen/form-screen/create_new_angsuran.dart';
import 'package:anugrah_lens/screen/home/bottom_screen.dart';
import 'package:anugrah_lens/screen/login/login_screen.dart';
import 'package:anugrah_lens/screen/test.dart';
import 'package:anugrah_lens/screen/testr.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white, // Warna dasar putih
          brightness: Brightness.light, // Mengatur tampilan terang
        ),
      ),
      home: FirstScreen(),
    );
  }
}

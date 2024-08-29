import 'package:anugrah_lens/screen/home/history_page_screen.dart';
import 'package:anugrah_lens/screen/home/home_page_screen.dart';
import 'package:anugrah_lens/widget/bottom_navbar_widget.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  final int? activeScreen;
  const FirstScreen({Key? key, this.activeScreen})
      : super(key: key);

  @override
  State<FirstScreen> createState() =>
      _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedNavbar = 0;
  @override
  void initState() {
    super.initState();
    // Jika activeScreen disetel, gunakan nilainya sebagai layar aktif
    if (widget.activeScreen != null) {
      _selectedNavbar = widget.activeScreen!;
    }
  }

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  Widget screenBottomNavigation(int index) {
    if (index == 0) {
      return BerandaPageScreen();
    } else {
      return RiwayatPageScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        child: screenBottomNavigation(_selectedNavbar),
      ),
      bottomNavigationBar: BottomNavbarWidget(
        currentIndex: _selectedNavbar,
        onTap: _changeSelectedNavbar,
      ),
    );
  }
}

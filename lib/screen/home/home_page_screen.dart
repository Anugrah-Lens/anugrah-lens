import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angsuran/menu_angsuran.dart';
import 'package:anugrah_lens/screen/form-screen/create_new_angsuran.dart';
import 'package:anugrah_lens/screen/login/login_screen.dart';
import 'package:anugrah_lens/services/customer_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:anugrah_lens/widget/floating_action_button_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerandaPageScreen extends StatefulWidget {
  BerandaPageScreen({Key? key}) : super(key: key);

  @override
  State<BerandaPageScreen> createState() => _BerandaPageScreenState();
}

class _BerandaPageScreenState extends State<BerandaPageScreen> {
  final CostumersService _costumersService = CostumersService();
  final TextEditingController name = TextEditingController();
  String? _photoUrl;
  String? _firstName;
  String? _email;
  String? _name;

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "";
      _firstName = _name?.split(' ')[0]; // Ambil bagian pertama (nama depan)
      _photoUrl = prefs.getString('photoUrl') ?? "";
      _email = prefs.getString('email') ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // preferensi pengguna

  Future<void> _handleSignOut() async {
    try {
      // Logout dari Firebase
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      // Hapus data dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Redirect ke layar login
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print('Sign out failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteColors,
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColors,
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            // 'Hello, thiyara',
            'Hello, ${_firstName ?? ''}',
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
              decoration: const BoxDecoration(
                color: ColorStyle.primaryColor, // Adjust the color as needed
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    // get from shared preferences
                    backgroundImage: NetworkImage(_photoUrl ??
                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                  ),
                  const SizedBox(
                      width: 16), // Space between the picture and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _firstName.toString(),
                        style: FontFamily.titleForm.copyWith(
                            color: ColorStyle.whiteColors,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _email.toString(),
                        style: FontFamily.caption
                            .copyWith(color: ColorStyle.whiteColors),
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
                _handleSignOut();
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
                _handleSignOut();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<CustomersModel>(
        future: _costumersService.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?.customer == null) {
            return const Center(child: Text('Tidak ada pelanggan'));
          }

          // Mengambil daftar pelanggan
          List<Customer> customers = snapshot.data!.customer!;

          /// tampilkan daftar pelanggan yang paymenStatus = Unpaid
          /// diambil dariu data customer.glasses.paymentStatus
          customers = customers
              .where((element) => element.glasses!
                  .any((element) => element.paymentStatus == 'Unpaid'))
              .toList();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text("Anugrah Lens", style: FontFamily.h3),
                ),
                const SizedBox(height: 10.0),
                SearchDropdownFieldHome(
                  onSelected: (String selectedName) {
                    // Memastikan navigasi hanya terjadi jika nama dipilih dari dropdown
                    Customer? selectedCustomer = customers
                        .firstWhere((element) => element.name == selectedName);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuAngsuranScreen(
                          idCustomer: selectedCustomer.id ?? '',
                          customerName: selectedCustomer.name ?? '',
                        ),
                      ),
                    );
                  },
                  prefixIcons: const Icon(Icons.search,
                      color: Color.fromARGB(255, 53, 35, 35)),
                  suffixIcons: null,
                  controller: name,
                  hintText: 'cari nama pelanggan',
                  items: customers.map((e) => e.name ?? '').toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];

                      // Select the first glass if it exists
                      Glass? selectedGlass =
                          customer.glasses?.isNotEmpty == true
                              ? customer.glasses!.first
                              : null;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CardNameWidget(
                          onPressed: () {
                            if (selectedGlass != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuAngsuranScreen(
                                    idCustomer: customer.id ?? '',
                                    customerName: customer.name ?? '',

                                    // Pass the selected glass ID
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'No glass available for this customer'),
                                ),
                              );
                            }
                          },
                          name: customer.name ?? 'Nama tidak tersedia',
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
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

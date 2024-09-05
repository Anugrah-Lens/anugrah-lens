import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/angusuran/menu_angsuran.dart';
import 'package:anugrah_lens/screen/form-screen/create_new_angsuran.dart';
import 'package:anugrah_lens/services/customer_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/card.dart';
import 'package:anugrah_lens/widget/floating_action_button_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:flutter/material.dart';

class BerandaPageScreen extends StatefulWidget {
  BerandaPageScreen({Key? key}) : super(key: key);

  @override
  State<BerandaPageScreen> createState() => _BerandaPageScreenState();
}

class _BerandaPageScreenState extends State<BerandaPageScreen> {
  final CostumersService _costumersService = CostumersService();
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
              decoration: const BoxDecoration(
                color: ColorStyle.primaryColor, // Adjust the color as needed
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: const NetworkImage(
                        'https://img.freepik.com/free-photo/business-finance-employment-female-successful-entrepreneurs-concept-confident-smiling-asian-businesswoman-office-worker-white-suit-glasses-using-laptop-help-clients_1258-59126.jpg?t=st=1724925519~exp=1724929119~hmac=c3b92a7be28ab28deebb3cd42b9755db39ca7267895a35ca60158967930094a2&w=740'), // Replace with your image URL
                  ),
                  const SizedBox(
                      width: 16), // Space between the picture and text
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
          final CustomersModel customersModel = snapshot.data!;

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
                SearchDropdownField(
                  onSelected: (String selectedName) {
                    // Memastikan navigasi hanya terjadi jika nama dipilih dari dropdown
                    Customer? selectedCustomer = customers
                        .firstWhere((element) => element.name == selectedName);
                    Glass? selectedGlass =
                        selectedCustomer.glasses?.isNotEmpty == true
                            ? selectedCustomer.glasses!.first
                            : null;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuAngsuranScreen(
                          idCustomer: selectedCustomer.id ?? '',
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

import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/screen/home/bottom_screen.dart';
import 'package:anugrah_lens/screen/home/home_page_screen.dart';
import 'package:anugrah_lens/services/add_customer.dart';
import 'package:anugrah_lens/services/customer_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/radio_button_widget.dart';
import 'package:anugrah_lens/widget/text_widget.dart';
import 'package:anugrah_lens/widget/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  // Controllers untuk mengelola input dari form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController frameController = TextEditingController();
  final TextEditingController lensTypeController = TextEditingController();
  final TextEditingController leftEyeController = TextEditingController();
  final TextEditingController rightEyeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController deliveryDateController = TextEditingController();

  String paymentMethod = 'Cash'; // Default payment method
  String _paymentStatus = 'Lunas';

  // Untuk menampilkan dialog date picker
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  final CostumersService _costumersService =
      CostumersService(); // Instance of your service
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers(); // Fetch data saat inisialisasi
  }

  // Fetch data customers
  Future<void> _fetchCustomers() async {
    try {
      final fetchedCustomers = await _costumersService.fetchCustomers();
      setState(() {
        customers =
            fetchedCustomers.customer ?? []; // Simpan daftar pelanggan di state
      });
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to fetch customers: $error'),
      ));
    }
  }

  String? selectedName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelanggan Baru',
            style: TextStyle(color: ColorStyle.secondaryColor)),
      ),
      body: customers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
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
                        onSelected: (String name) {
                          setState(() {
                            nameController.text =
                                name; // Update controller dengan nama yang dipilih
                          });
                        },
                        onChange: (String value) {
                          setState(() {
                            nameController.text = value;
                          });
                        },
                        controller: nameController,
                        hintText: 'Cari nama pelanggan',
                        items: customers.map((e) => e.name ?? '').toList(),
                        prefixIcons: null,
                        suffixIcons: const Icon(Icons.arrow_drop_down,
                            color: ColorStyle.primaryColor),
                      ),
                      const SizedBox(height: 4.0),
                      const TitleTextWIdget(
                        name: 'No Telepon',
                      ),
                      TextFieldWidget(
                        controller: phoneController,
                        hintText: 'e.g. 08123456789',
                      ),
                      const SizedBox(height: 4.0),
                      TitleTextWIdget(
                        name: 'Alamat',
                      ),
                      TextFieldWidget(
                        controller: addressController,
                        hintText: 'e.g. Alamat',
                      ),
                      const SizedBox(height: 20.0),
                      const TitleTextWIdget(
                        name: 'Nama gagang (Frame)',
                      ),
                      TextFieldWidget(
                        controller: frameController,
                        hintText: 'e.g. duvali 883',
                      ),
                      const SizedBox(height: 4.0),
                      const TitleTextWIdget(
                        name: 'Jenis Kaca',
                      ),
                      TextFieldWidget(
                        controller: lensTypeController,
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
                                controller: leftEyeController,
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
                                controller: rightEyeController,
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
                        controller: priceController,
                        hintText: 'e.g. 500.000',
                      ),
                      const SizedBox(height: 4.0),
                      const TitleTextWIdget(
                        name: 'Deposit(DP)',
                      ),
                      TextFieldWidget(
                        controller: depositController,
                        hintText: 'e.g. 100.000',
                      ),
                      const SizedBox(height: 20.0),
                      const TitleTextWIdget(
                        name: 'Tanggal Pesanan',
                      ),
                      TextFieldCalenderWidget(
                        controller: orderDateController,
                        hintText: 'e.g. 23 Februari 2022',
                      ),
                      const SizedBox(height: 4.0),
                      const TitleTextWIdget(
                        name: 'Tanggal Antaran',
                      ),
                      TextFieldCalenderWidget(
                        controller: deliveryDateController,
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
                              value: 'Cash',
                              groupValue: _paymentStatus,
                              text: 'Cash',
                              onChanged: (String? value) {
                                setState(() {
                                  _paymentStatus = value!;
                                });
                              },
                            ),
                            RadioButtonWidget(
                              value: 'Installments',
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
                        onPressed: () async {
                          try {
                            if (nameController.text.isEmpty) {
                              throw Exception(
                                  "Nama pelanggan tidak boleh kosong.");
                            }
                            if (phoneController.text.isEmpty) {
                              throw Exception(
                                  "Nomor telepon tidak boleh kosong.");
                            }
                            if (addressController.text.isEmpty) {
                              throw Exception("Alamat tidak boleh kosong.");
                            }
                            if (frameController.text.isEmpty) {
                              throw Exception(
                                  "Nama gagang (Frame) tidak boleh kosong.");
                            }
                            if (lensTypeController.text.isEmpty) {
                              throw Exception("Jenis kaca tidak boleh kosong.");
                            }
                            if (leftEyeController.text.isEmpty) {
                              throw Exception(
                                  "Ukuran mata kiri tidak boleh kosong.");
                            }
                            if (rightEyeController.text.isEmpty) {
                              throw Exception(
                                  "Ukuran mata kanan tidak boleh kosong.");
                            }
                            if (priceController.text.isEmpty) {
                              throw Exception(
                                  "Harga kaca mata tidak boleh kosong.");
                            }
                            if (depositController.text.isEmpty) {
                              throw Exception("Deposit tidak boleh kosong.");
                            }
                            if (orderDateController.text.isEmpty) {
                              throw Exception(
                                  "Tanggal pesanan tidak boleh kosong.");
                            }
                            if (deliveryDateController.text.isEmpty) {
                              throw Exception(
                                  "Tanggal antaran tidak boleh kosong.");
                            }
                            // Validate input values
                            if (nameController.text.isEmpty ||
                                phoneController.text.isEmpty ||
                                addressController.text.isEmpty ||
                                frameController.text.isEmpty ||
                                lensTypeController.text.isEmpty ||
                                leftEyeController.text.isEmpty ||
                                rightEyeController.text.isEmpty ||
                                priceController.text.isEmpty ||
                                depositController.text.isEmpty ||
                                orderDateController.text.isEmpty ||
                                deliveryDateController.text.isEmpty) {
                              throw Exception("All fields are required.");
                            }

                            // Parsing input values
                            final String customerName =
                                nameController.text.trim(); //
                            final String phone = phoneController.text;
                            final String address = addressController.text;
                            final String frame = frameController.text;
                            final String lensType = lensTypeController.text;
                            final String leftEye = leftEyeController.text;
                            final String rightEye = rightEyeController.text;
                            final int price = int.parse(
                                priceController.text.replaceAll(',', ''));
                            final int deposit = int.parse(
                                depositController.text.replaceAll(',', ''));

                            // Parsing dates
                            DateTime selectedOrderDate =
                                DateFormat('dd MMMM yyyy')
                                    .parse(orderDateController.text)
                                    .toUtc();
                            String formattedOrderDate =
                                selectedOrderDate.toIso8601String();

                            DateTime selectedDeliveryDate =
                                DateFormat('dd MMMM yyyy')
                                    .parse(deliveryDateController.text)
                                    .toUtc();
                            String formattedDeliveryDate =
                                selectedDeliveryDate.toIso8601String();

                            final String paymentMethod = _paymentStatus;

                            print('Sending data:');
                            print('Name: $customerName');
                            print('Phone: $phone');
                            print('Address: $address');
                            print('Frame: $frame');
                            print('Lens Type: $lensType');
                            print('Left Eye: $leftEye');
                            print('Right Eye: $rightEye');
                            print('Price: $price');
                            print('Deposit: $deposit');
                            print('Order Date: $formattedOrderDate');
                            print('Delivery Date: $formattedDeliveryDate');
                            print('Payment Method: $paymentMethod');

                            // Call addCustomer service
                            final responseMessage =
                                await CustomerService().addCustomer(
                              name: customerName,

                              /// int ubah ke bigint
                              phone: phone,
                              address: address,
                              frame: frame,
                              lensType: lensType,
                              left: leftEye,
                              right: rightEye,
                              price: price,
                              deposit: deposit,
                              orderDate: formattedOrderDate,
                              deliveryDate: formattedDeliveryDate,
                              paymentMethod: paymentMethod,
                            );

                            // Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  responseMessage,
                                  style: FontFamily.caption
                                      .copyWith(color: ColorStyle.whiteColors),
                                ),
                                backgroundColor: ColorStyle.successColor,
                              ),
                            );

                            /// navigate to home screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstScreen(
                                  activeScreen: 0,
                                ),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error: ${e.toString()}',
                                  style: FontFamily.caption
                                      .copyWith(color: ColorStyle.whiteColors),
                                ),
                                backgroundColor: ColorStyle.errorColor,
                              ),
                            );
                          }
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

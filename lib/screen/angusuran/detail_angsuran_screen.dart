import 'package:anugrah_lens/models/customer_data_model.dart';
import 'package:anugrah_lens/screen/angusuran/table_angsuran.dart';
import 'package:anugrah_lens/services/customer_services.dart';
import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:anugrah_lens/widget/Button_widget.dart';
import 'package:anugrah_lens/widget/text_widget.dart';
import 'package:flutter/material.dart';

class DetailAngsuranSCreen extends StatefulWidget {
  final String idCustomer;
  final String idGlass;

  DetailAngsuranSCreen({
    Key? key,
    required this.idCustomer,
    required this.idGlass,
  }) : super(key: key);

  @override
  State<DetailAngsuranSCreen> createState() => _DetailAngsuranSCreenState();
}

class _DetailAngsuranSCreenState extends State<DetailAngsuranSCreen> {
  late Future<CustomerData> customersData;
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    customersData = CostumersService().fetchCustomerById(widget.idCustomer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pelanggan Baru',
          style: FontFamily.subtitle.copyWith(color: ColorStyle.secondaryColor),
        ),
      ),
      body: FutureBuilder<CustomerData>(
        future: customersData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2.0,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final customer = snapshot.data!.customer!;
            final glasses = customer.glasses
                    ?.where((glass) => glass.paymentMethod == 'Installments')
                    .toList() ??
                [];

            /// seletedGlass dibambi dari customer.glasses yang sama dengan idGlass bukan yang pertam
            final selectedGlass = glasses.firstWhere(
                (glass) => glass.id == widget.idGlass,
                orElse: () => Glass());
            if (glasses.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('No data available')),
                    )),
              );
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitleTextWIdget(name: 'Nama Pelanggan'),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              customer.name.toString(),
                              style: FontFamily.caption,
                            ),
                          ),
                          const TitleTextWIdget(name: 'Alamat'),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              customer.address.toString(),
                              style: FontFamily.caption,
                            ),
                          ),
                          const TitleTextWIdget(name: 'No Telepon'),
                          Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text(
                              customer.phone.toString(),
                              style: FontFamily.caption,
                            ),
                          ),
                          if (_isExpanded &&
                              customer.glasses?.isNotEmpty == true) ...[
                            const SizedBox(height: 20.0),
                            const TitleTextWIdget(name: 'Nama Gagang(Frame)'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass?.frame ?? 'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            const TitleTextWIdget(name: 'Jenis Kaca'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass!.lensType ?? 'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            const TitleTextWIdget(name: 'Ukuran'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Left : ${selectedGlass.left ?? 'Tidak tersedia'}',
                                  style: FontFamily.caption,
                                ),
                                Text(
                                  'Right : ${selectedGlass.right ?? 'Tidak tersedia'}',
                                  style: FontFamily.caption,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const TitleTextWIdget(name: 'Tanggal Pemesanan'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass.orderDate ?? 'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const TitleTextWIdget(name: 'Tanggal Pengantaran'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass.deliveryDate ?? 'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            const TitleTextWIdget(name: 'Harga'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass.price?.toString() ??
                                    'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            const TitleTextWIdget(name: 'Deposit(DP)'),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                selectedGlass.deposit?.toString() ??
                                    'Tidak tersedia',
                                style: FontFamily.caption,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                'Sisa Pembayaran: ${selectedGlass.price! - selectedGlass.deposit!}',
                                style: FontFamily.caption
                                    .copyWith(color: ColorStyle.errorColor),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: _toggleExpansion,
                          child: Text(
                            _isExpanded
                                ? 'Lihat lebih sedikit'
                                : 'Lihat selengkapnya',
                            style: FontFamily.titleForm
                                .copyWith(color: ColorStyle.secondaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Metode Pembayaran',
                          style: FontFamily.title.copyWith(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedGlass!.paymentMethod ?? 'Tidak tersedia',
                              style: FontFamily.titleForm.copyWith(
                                color: ColorStyle.textColors,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              selectedGlass.paymentStatus == 'Paid'
                                  ? 'Lunas'
                                  : 'Belum Lunas',
                              style: FontFamily.titleForm.copyWith(
                                color: selectedGlass.paymentStatus == 'Paid'
                                    ? ColorStyle.successColor
                                    : ColorStyle.errorColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButtonWidget(
                        color: ColorStyle.primaryColor,
                        text: 'Lihat Pembayaran',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTableAngsuran(
                                idCustomer: widget.idCustomer,
                                glassId: widget.idGlass,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

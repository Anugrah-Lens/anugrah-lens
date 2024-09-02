import 'package:anugrah_lens/models/community_model.dart';
import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/style/base_url.dart';
import 'package:dio/dio.dart';

class CostumersService {
  final Dio _dio = Dio();

  // Ganti baseURL dengan URL yang sesuai dengan endpoint API Anda

  Future<CustomersModel> fetchCustomers() async {
    try {
      final response =
          await _dio.get("https://vh9fszkr-9000.asse.devtunnels.ms/customers");
      return CustomersModel.fromMap(response.data);
    } catch (error) {
      throw Exception("Failed to fetch Communities: $error");
    }
  }
}

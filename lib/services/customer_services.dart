import 'package:anugrah_lens/models/customer_data_model.dart';
import 'package:anugrah_lens/models/customers_model.dart';
import 'package:anugrah_lens/style/base_url.dart';
import 'package:dio/dio.dart';

class CostumersService {
  final Dio _dio = Dio();

  Future<CustomersModel> fetchCustomers() async {
    try {
      final response = await _dio.get("$baseUrl/customers");
      return CustomersModel.fromMap(response.data);
    } catch (error) {
      throw Exception("Failed to fetch Communities: $error");
    }
  }

  // fetch customerbyid
  Future<CustomerData> fetchCustomerById(String id) async {
    try {
      final response = await _dio.get("$baseUrl/customer/$id");
      return CustomerData.fromMap(response.data);
    } catch (error) {
      throw Exception("Failed to fetch Communities: $error");
    }
  }
}

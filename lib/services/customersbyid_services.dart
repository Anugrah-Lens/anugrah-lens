
// import 'package:anugrah_lens/models/customersGlasses_model.dart';
// import 'package:anugrah_lens/style/base_url.dart';
// import 'package:dio/dio.dart';

// class CostumersGlassesService {
//   final Dio _dio = Dio();

//   // Ganti baseURL dengan URL yang sesuai dengan endpoint API Anda

//   Future<CustomersSpecificModel> fetchCustomersGlasses(String userId) async {
//     try {
//       final response = await _dio.get("$baseUrl/customer/$userId");

//       if (response.statusCode == 200) {
//         return CustomersSpecificModel.fromMap(response.data);
//       } else {
//         throw Exception("Failed to fetch data: ${response.statusCode}");
//       }
//     } catch (error) {
//       throw Exception("Failed to fetch Communities: $error");
//     }
//   }
// }


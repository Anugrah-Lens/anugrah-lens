// import 'package:dio/dio.dart';

// class UpdatePaymentService {
//   final Dio _dio = Dio();

//   Future<void> updateInstallment(String installmentId, int amount) async {
//     try {
//       final response = await _dio.put(
//         'https://yourapi.com/edit-installment/$installmentId',
//         data: {
//           'amount': amount,
//         },
//       );

//       if (response.statusCode == 200) {
//         // Handle successful response
//         print('Installment updated successfully');
//       } else {
//         // Handle error response
//         throw Exception('Failed to update installment');
//       }
//     } catch (e) {
//       // Handle exception
//       print('Failed to update installment: $e');
//       throw Exception('Failed to update installment: $e');
//     }
//   }
// }

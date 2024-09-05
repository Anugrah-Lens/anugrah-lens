import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://vh9fszkr-9000.asse.devtunnels.ms';

  Future<Map<String, dynamic>> addPaymentDataAmount(
      int bayar, String glassId, String paidDate) async {
    try {
      Response response = await _dio.post(
        '$baseUrl/add-installment/$glassId',
        data: {
          'amount': bayar,
          'paidDate': paidDate,
        },
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'total': response.data['installment']['total'],
          'remaining': response.data['installment']['remaining'],
          'message': response.data['message'], // Pesan sukses dari server
        };
      } else if (response.statusCode == 400) {
        // Jika status code 400, berarti ada kesalahan input (bad request)
        return {
          'success': false,
          'message': response.data['message'] ?? 'Bad request',
        };
      } else {
        // Jika status code lainnya
        throw Exception('Failed to fetch payment data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: $e');
      throw Exception('Failed to fetch payment data: ${e.message}');
    } catch (e) {
      print('General error: $e');
      throw Exception('Failed to fetch payment data');
    }
  }

  Future<String> editInstallment(
      String installmentId, int amount, String paidDate) async {
    try {
      final response =
          await _dio.put('$baseUrl/edit-installment/$installmentId', data: {
        'amount': amount,
        'paidDate': paidDate,
      });

      if (response.statusCode == 200) {
        print('Installment updated successfully');
        return response.data['message'] ??
            'Installment updated successfully'; // Ambil pesan dari response
      } else {
        print(
            'Failed to update installment. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to update installment: ${response.data['message']}'); // Ambil pesan dari response
      }
    } catch (e) {
      print('Error during installment update: $e');
      throw Exception('Error during installment update: $e');
    }
  }

  // Add any additional methods here if needed
}

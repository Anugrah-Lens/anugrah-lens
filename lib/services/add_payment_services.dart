import 'package:dio/dio.dart';

class PaymentService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://vh9fszkr-9000.asse.devtunnels.ms';

  Future<Map<String, dynamic>> fetchPaymentDataFromBackend(
      int bayar, String glassId) async {
    try {
      print('Mengirim permintaan ke: $baseUrl/add-installment/$glassId');
      print('Dengan data: amount = $bayar');

      Response response = await _dio.post(
        '$baseUrl/add-installment/$glassId',
        data: {
          'amount': bayar,
        },
        options: Options(
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        return {
          'total': response.data['installment']['total'],
          'remaining': response.data['installment']['remaining'],
        };
      } else {
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

  Future<void> updateInstallment(String installmentId, int amount) async {
    print(
        'updateInstallment called with installmentId: $installmentId, amount: $amount');
    try {
      final response =
          await _dio.put('$baseUrl/edit-installment/$installmentId', data: {
        'amount': amount,
      });

      if (response.statusCode == 200) {
        print('Installment updated successfully');
      } else {
        print(
            'Failed to update installment. Status code: ${response.statusCode}');
        throw Exception('Failed to update installment');
      }
    } catch (e) {
      print('Error during installment update: $e');
      throw Exception('Error during installment update');
    }
  }

  // Add any additional methods here if needed
}

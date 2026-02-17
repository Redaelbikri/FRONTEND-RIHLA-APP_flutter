import 'package:dio/dio.dart';
import '../models/payment_model.dart';
import '../services/api_client.dart';

class PaymentsApi {
  final Dio _dio = ApiClient().dio;

  Future<PaymentIntentResponse> createIntent({
    required String reservationId,
    required int amountMad,
  }) async {
    final res = await _dio.post(
      '/api/payments/create-intent',
      data: {
        'reservationId': reservationId,
        'amountMad': amountMad,
      },
    );
    return PaymentIntentResponse.fromJson((res.data as Map).cast<String, dynamic>());
  }

  Future<List<dynamic>> myPayments() async {
    final res = await _dio.get('/api/payments/me');
    return (res.data as List).cast<dynamic>();
  }
}

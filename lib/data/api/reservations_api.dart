import 'package:dio/dio.dart';
import '../models/reservation_model.dart';
import '../services/api_client.dart';

class ReservationsApi {
  final Dio _dio = ApiClient().dio;

  Future<ReservationModel> create({
    String? transportId,
    int? transportQty,
    String? hebergementId,
    int? hebergementQty,
    String? eventId,
    int? eventQty,
  }) async {
    final data = <String, dynamic>{};

    if (transportId != null) {
      data['transport'] = {'id': transportId, 'quantity': transportQty ?? 1};
    }
    if (hebergementId != null) {
      data['hebergement'] = {'id': hebergementId, 'quantity': hebergementQty ?? 1};
    }
    if (eventId != null) {
      data['event'] = {'id': eventId, 'quantity': eventQty ?? 1};
    }

    final res = await _dio.post('/api/reservations', data: data);
    return ReservationModel.fromJson((res.data as Map).cast<String, dynamic>());
  }

  Future<List<ReservationModel>> myReservations() async {
    final res = await _dio.get('/api/reservations/me');
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => ReservationModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<ReservationModel> cancel(String id) async {
    final res = await _dio.put('/api/reservations/$id/cancel');
    return ReservationModel.fromJson((res.data as Map).cast<String, dynamic>());
  }
}

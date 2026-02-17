import 'package:dio/dio.dart';
import '../models/trip_model.dart';
import '../services/api_client.dart';

class TripsApi {
  final Dio _dio = ApiClient().dio;

  Future<List<TripModel>> search({
    required String fromCity,
    required String toCity,
    required String date, // YYYY-MM-DD (backend LocalDate)
    required String type, // BUS/TRAIN/TAXI/FLIGHT
  }) async {
    final res = await _dio.get(
      '/api/transports/trips/search',
      queryParameters: {
        'fromCity': fromCity,
        'toCity': toCity,
        'date': date,
        'type': type,
      },
    );
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => TripModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<bool> check(String id, int quantity) async {
    final res = await _dio.get('/api/transports/trips/$id/check', queryParameters: {'quantity': quantity});
    return res.data == true;
  }
}

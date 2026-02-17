import 'package:dio/dio.dart';

import '../models/hotel_model.dart';
import '../services/api_client.dart';


class HebergementsApi {
  final Dio _dio = ApiClient().dio;

  /// Backend: GET /api/hebergements?city=...&maxPrice=...
  Future<List<HotelModel>> fetchHebergements({
    String? city,
    num? maxPrice,
  }) async {
    final res = await _dio.get(
      '/api/hebergements',
      queryParameters: {
        if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
        if (maxPrice != null) 'maxPrice': maxPrice,
      },
    );

    final data = res.data;
    if (data is List) {
      return data
          .map((e) => HotelModel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    }

    return const <HotelModel>[];
  }
}

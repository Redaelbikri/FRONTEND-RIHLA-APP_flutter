import 'package:dio/dio.dart';
import '../models/event_model.dart';
import '../services/api_client.dart';

class EventsApi {
  final Dio _dio = ApiClient().dio;

  Future<List<EventModel>> getAll() async {
    final res = await _dio.get('/api/events');
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => EventModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<List<EventModel>> filterByCategory(String category) async {
    final res = await _dio.get('/api/events/filter/category/$category');
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => EventModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<List<EventModel>> filterByCity(String city) async {
    final res = await _dio.get('/api/events/filter/city/$city');
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => EventModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<List<EventModel>> search(String keyword) async {
    final res = await _dio.get('/api/events/search', queryParameters: {'keyword': keyword});
    final list = (res.data as List).cast<dynamic>();
    return list.map((e) => EventModel.fromJson((e as Map).cast<String, dynamic>())).toList();
  }

  Future<bool> check(String id, int quantity) async {
    final res = await _dio.get('/api/events/$id/check', queryParameters: {'quantity': quantity});
    return (res.data == true);
  }

  Future<void> reduceStock(String id, int quantity) async {
    await _dio.put('/api/events/$id/reduce-stock', queryParameters: {'quantity': quantity});
  }
}

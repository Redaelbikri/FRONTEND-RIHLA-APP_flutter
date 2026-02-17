import 'package:dio/dio.dart';

import '../services/api_client.dart';
import '../models/notification_model.dart';

class NotificationsApi {
  final Dio _dio = ApiClient().dio;

  Future<List<NotificationModel>> myNotifications() async {
    try {
      final res = await _dio.get('/api/notifications/me');
      final data = res.data;

      if (data is List) {
        return data
            .whereType<dynamic>()
            .map((e) => NotificationModel.fromJson((e as Map).cast<String, dynamic>()))
            .toList();
      }

      return const <NotificationModel>[];
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<int> unreadCount() async {
    try {
      final res = await _dio.get('/api/notifications/me/unread-count');
      final data = (res.data as Map).cast<String, dynamic>();
      final unread = data['unread'];
      if (unread is int) return unread;
      return int.tryParse(unread?.toString() ?? '0') ?? 0;
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _dio.put('/api/notifications/$id/read');
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }
}

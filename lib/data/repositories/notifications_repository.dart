import '../api/notifications_api.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final NotificationsApi _api;
  NotificationsRepository(this._api);

  Future<List<NotificationModel>> mine() => _api.myNotifications();
  Future<int> unreadCount() => _api.unreadCount();
  Future<void> markRead(String id) => _api.markRead(id);
}

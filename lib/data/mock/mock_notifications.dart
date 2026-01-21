import '../models/notification_model.dart';

class MockNotifications {
  static const items = <NotificationModel>[
    NotificationModel(
      id: 'ntf_1',
      title: 'Itinerary saved',
      message: 'Your Marrakech weekend plan is ready to review.',
      time: '2m ago',
      iconKey: 'check',
    ),
    NotificationModel(
      id: 'ntf_2',
      title: 'Event reminder',
      message: 'Souks Tour starts in 3 hours. Don’t forget your camera.',
      time: '1h ago',
      iconKey: 'bell',
    ),
  ];
}

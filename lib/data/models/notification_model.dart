class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String time;
  final String iconKey;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.iconKey,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    message: (json['message'] ?? '').toString(),
    time: (json['time'] ?? '').toString(),
    iconKey: (json['iconKey'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'time': time,
    'iconKey': iconKey,
  };
}

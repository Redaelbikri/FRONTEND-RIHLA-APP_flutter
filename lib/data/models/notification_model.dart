class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime? dt;
    final raw = json['createdAt']?.toString();
    if (raw != null && raw.trim().isNotEmpty) {
      dt = DateTime.tryParse(raw);
    }

    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      read: (json['read'] is bool) ? (json['read'] as bool) : false,
      createdAt: dt,
    );
  }
}

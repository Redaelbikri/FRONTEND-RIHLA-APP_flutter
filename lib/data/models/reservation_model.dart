class ReservationModel {
  final String id;
  final String userSubject;
  final String status;
  final DateTime? createdAt;

  final String? transportTripId;
  final int? transportSeats;

  final String? hebergementId;
  final int? hebergementRooms;

  final String? eventId;
  final int? eventTickets;

  ReservationModel({
    required this.id,
    required this.userSubject,
    required this.status,
    required this.createdAt,
    this.transportTripId,
    this.transportSeats,
    this.hebergementId,
    this.hebergementRooms,
    this.eventId,
    this.eventTickets,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: (json['id'] ?? '').toString(),
      userSubject: (json['userSubject'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()),
      transportTripId: json['transportTripId']?.toString(),
      transportSeats: (json['transportSeats'] as num?)?.toInt(),
      hebergementId: json['hebergementId']?.toString(),
      hebergementRooms: (json['hebergementRooms'] as num?)?.toInt(),
      eventId: json['eventId']?.toString(),
      eventTickets: (json['eventTickets'] as num?)?.toInt(),
    );
  }
}

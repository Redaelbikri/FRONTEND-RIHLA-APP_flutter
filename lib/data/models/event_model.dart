class EventModel {
  final String id;
  final String nom;
  final String description;
  final String lieu;
  final String categorie;
  final DateTime? dateEvent; // backend LocalDateTime
  final double prix;
  final int placesDisponibles;
  final String imageUrl;

  EventModel({
    required this.id,
    required this.nom,
    required this.description,
    required this.lieu,
    required this.categorie,
    required this.dateEvent,
    required this.prix,
    required this.placesDisponibles,
    required this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['dateEvent']?.toString();
    return EventModel(
      id: (json['id'] ?? '').toString(),
      nom: (json['nom'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      lieu: (json['lieu'] ?? '').toString(),
      categorie: (json['categorie'] ?? '').toString(),
      dateEvent: rawDate == null || rawDate.isEmpty ? null : DateTime.tryParse(rawDate),
      prix: (json['prix'] as num?)?.toDouble() ?? 0.0,
      placesDisponibles: (json['placesDisponibles'] as num?)?.toInt() ?? 0,
      imageUrl: (json['imageUrl'] ?? '').toString(),
    );
  }
}

class EventModel {
  final int id;
  final String nom;
  final String description;
  final String lieu;
  final String categorie;
  final String dateEvent;
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
    return EventModel(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      lieu: json['lieu'],
      categorie: json['categorie'],
      dateEvent: json['dateEvent'],
      prix: (json['prix'] as num).toDouble(),
      placesDisponibles: json['placesDisponibles'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

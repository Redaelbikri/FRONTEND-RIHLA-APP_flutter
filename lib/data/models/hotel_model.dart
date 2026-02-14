class HotelModel {
  final int id;
  final String nom;
  final String ville;
  final String adresse;
  final String type;
  final double prixParNuit;
  final int chambresDisponibles;
  final double note;
  final String imageUrl;
  final bool actif;

  HotelModel({
    required this.id,
    required this.nom,
    required this.ville,
    required this.adresse,
    required this.type,
    required this.prixParNuit,
    required this.chambresDisponibles,
    required this.note,
    required this.imageUrl,
    required this.actif,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'],
      nom: json['nom'] ?? '',
      ville: json['ville'] ?? '',
      adresse: json['adresse'] ?? '',
      type: json['type'] ?? '',
      prixParNuit: (json['prixParNuit'] as num?)?.toDouble() ?? 0.0,
      chambresDisponibles: json['chambresDisponibles'] ?? 0,
      note: (json['note'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      actif: json['actif'] ?? true,
    );
  }
}

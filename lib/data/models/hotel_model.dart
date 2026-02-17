class HotelModel {
  final String? id;
  final String? nom;
  final String? ville;
  final String? type;
  // Enum côté backend :
  // HOTEL, RIAD, APPARTEMENT, MAISON_HOTE

  final num? prixParNuit;
  final num? note;
  final String? imageUrl;
  final int? chambresDisponibles;

  const HotelModel({
    this.id,
    this.nom,
    this.ville,
    this.type,
    this.prixParNuit,
    this.note,
    this.imageUrl,
    this.chambresDisponibles,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id']?.toString(),
      nom: json['nom']?.toString(),
      ville: json['ville']?.toString(),
      type: json['type']?.toString(),
      prixParNuit: json['prixParNuit'] as num?,
      note: json['note'] as num?,
      imageUrl: json['imageUrl']?.toString(),
      chambresDisponibles: json['chambresDisponibles'] is int
          ? json['chambresDisponibles'] as int
          : int.tryParse('${json['chambresDisponibles']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'ville': ville,
      'type': type,
      'prixParNuit': prixParNuit,
      'note': note,
      'imageUrl': imageUrl,
      'chambresDisponibles': chambresDisponibles,
    };
  }
}

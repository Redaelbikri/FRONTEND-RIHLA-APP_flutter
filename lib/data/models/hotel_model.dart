class HotelModel {
  final String id;
  final String name;
  final String city;
  final String image;
  final double rating;
  final int pricePerNight;
  final String tag;

  const HotelModel({
    required this.id,
    required this.name,
    required this.city,
    required this.image,
    required this.rating,
    required this.pricePerNight,
    required this.tag,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) => HotelModel(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    city: (json['city'] ?? '').toString(),
    image: (json['image'] ?? '').toString(),
    rating: ((json['rating'] ?? 0) as num).toDouble(),
    pricePerNight: (json['pricePerNight'] ?? 0) as int,
    tag: (json['tag'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'image': image,
    'rating': rating,
    'pricePerNight': pricePerNight,
    'tag': tag,
  };
}

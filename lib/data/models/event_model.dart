class EventModel {
  final String id;
  final String title;
  final String category; // Culture, Food, Music, Art, Nature, Sport...
  final String image;
  final String location;
  final String dateLabel;
  final String description;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.location,
    required this.dateLabel,
    required this.description,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    category: (json['category'] ?? '').toString(),
    image: (json['image'] ?? '').toString(),
    location: (json['location'] ?? '').toString(),
    dateLabel: (json['dateLabel'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'image': image,
    'location': location,
    'dateLabel': dateLabel,
    'description': description,
  };
}

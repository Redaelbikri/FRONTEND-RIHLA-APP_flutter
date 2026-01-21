class ReviewModel {
  final String id;
  final String name;
  final double rating;
  final String comment;
  final String timeAgo;

  const ReviewModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    rating: ((json['rating'] ?? 0) as num).toDouble(),
    comment: (json['comment'] ?? '').toString(),
    timeAgo: (json['timeAgo'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rating': rating,
    'comment': comment,
    'timeAgo': timeAgo,
  };
}

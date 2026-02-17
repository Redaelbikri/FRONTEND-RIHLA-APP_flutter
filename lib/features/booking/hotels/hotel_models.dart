class HotelReview {
  final String author;
  final String comment;
  final double rating;

  const HotelReview({
    required this.author,
    required this.comment,
    required this.rating,
  });
}

class Hotel {
  final String id;
  final String name;
  final String city;
  final String image;
  final double rating;
  final int reviewsCount;
  final int priceMadPerNight;
  final List<String> tags;
  final List<HotelReview> reviews;

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.image,
    required this.rating,
    required this.reviewsCount,
    required this.priceMadPerNight,
    required this.tags,
    required this.reviews,
  });
}

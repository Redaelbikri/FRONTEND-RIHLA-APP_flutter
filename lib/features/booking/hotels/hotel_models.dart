import 'package:flutter/material.dart';

class HotelReview {
  final String name;
  final double rating;
  final String comment;
  final String timeAgo;

  const HotelReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}
class Hotel {
  final String name;
  final String city;
  final String image;
  final double rating;
  final int reviewsCount;
  final int priceMadPerNight;
  final List<String> tags;
  final List<HotelReview> reviews;

  const Hotel({
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

class HotelMock {
  static List<Hotel> hotels(String city) {
    return [
      Hotel(
        name: 'Riad Noor',
        city: city,
        image: 'assets/hotels/hotel_1.jpg',
        rating: 4.8,
        reviewsCount: 124,
        priceMadPerNight: 680,
        tags: const ['Riad', 'Breakfast', 'Old Medina'],
        reviews: const [
          HotelReview(
            name: 'Sara',
            rating: 5.0,
            comment: 'Stunning riad, super clean and very authentic.',
            timeAgo: '2d ago',
          ),
          HotelReview(
            name: 'Youssef',
            rating: 4.6,
            comment: 'Great location, calm vibes, staff very friendly.',
            timeAgo: '1w ago',
          ),
        ],
      ),
      Hotel(
        name: 'Atlas View Hotel',
        city: city,
        image: 'assets/hotels/hotel_2.jpg',
        rating: 4.5,
        reviewsCount: 870,
        priceMadPerNight: 540,
        tags: const ['City view', 'WiFi', 'Business'],
        reviews: const [
          HotelReview(
            name: 'Amine',
            rating: 4.5,
            comment: 'Nice rooms, fast check-in, very good value.',
            timeAgo: '3d ago',
          ),
        ],
      ),
      Hotel(
        name: 'Kasbah Palm Resort',
        city: city,
        image: 'assets/hotels/hotel_3.jpg',
        rating: 4.7,
        reviewsCount: 450,
        priceMadPerNight: 920,
        tags: const ['Pool', 'Spa', 'Premium'],
        reviews: const [
          HotelReview(
            name: 'Lina',
            rating: 4.8,
            comment: 'Amazing pool and spa, perfect weekend getaway.',
            timeAgo: '5d ago',
          ),
          HotelReview(
            name: 'Omar',
            rating: 4.4,
            comment: 'Great service, food was delicious.',
            timeAgo: '2w ago',
          ),
        ],
      ),
    ];
  }
}

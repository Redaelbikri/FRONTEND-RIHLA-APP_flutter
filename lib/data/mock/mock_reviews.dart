import '../models/review_model.dart';

class MockReviews {
  static const items = <ReviewModel>[
    ReviewModel(
      id: 'rv_1',
      name: 'Yassine',
      rating: 4.9,
      comment: 'The itinerary flow feels premium. Everything is organized.',
      timeAgo: '1d ago',
    ),
    ReviewModel(
      id: 'rv_2',
      name: 'Salma',
      rating: 4.7,
      comment: 'Loved the events discovery. Great suggestions and UI.',
      timeAgo: '3d ago',
    ),
    ReviewModel(
      id: 'rv_3',
      name: 'Omar',
      rating: 4.8,
      comment: 'Transport search is smooth. Cards look like real store apps.',
      timeAgo: '1w ago',
    ),
  ];
}

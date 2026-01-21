class MockDestination {
  final String title;
  final String subtitle;
  final String image;
  final String tag;

  const MockDestination({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
  });
}

class MockEvent {
  final String title;
  final String category;
  final String image;
  final String location;
  final String dateLabel;
  final String description;

  const MockEvent({
    required this.title,
    required this.category,
    required this.image,
    required this.location,
    required this.dateLabel,
    required this.description,
  });
}

class MockNotificationItem {
  final String title;
  final String message;
  final String time;
  final String iconKey;

  const MockNotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.iconKey,
  });
}

class MockData {
  static const destinations = <MockDestination>[
    MockDestination(
      title: 'Marrakech',
      subtitle: 'Souks, riads & sunset tea',
      image: 'assets/destinations/marrakech.jpg',
      tag: 'Trending',
    ),
    MockDestination(
      title: 'Atlas Mountains',
      subtitle: 'Trekking & panoramic views',
      image: 'assets/destinations/atlas.jpg',
      tag: 'Nature',
    ),
    MockDestination(
      title: 'Chefchaouen',
      subtitle: 'Blue alleys & calm vibes',
      image: 'assets/destinations/chefchaouen.jpg',
      tag: 'Relax',
    ),
    MockDestination(
      title: 'Sahara Desert',
      subtitle: 'Dunes, camp & stargazing',
      image: 'assets/destinations/desert.jpg',
      tag: 'Adventure',
    ),
  ];

  static const events = <MockEvent>[
    MockEvent(
      title: 'Souks Tour',
      category: 'Culture',
      image: 'assets/events/souk_tour.jpg',
      location: 'Marrakech',
      dateLabel: 'Sat, 18 Oct · 10:00',
      description:
      'Explore hidden souks with a local guide, discover artisan corners, and taste traditional street snacks.',
    ),
    MockEvent(
      title: 'Medina Cooking Class',
      category: 'Food',
      image: 'assets/events/cooking_class.jpg',
      location: 'Fes',
      dateLabel: 'Mon, 21 Oct · 16:30',
      description:
      'Hands-on cooking workshop: tajine, zaalouk, and mint tea rituals in an authentic Moroccan home.',
    ),
    MockEvent(
      title: 'African Cup of Nations',
      category: 'Sport',
      image: 'assets/events/afcon.jpg',
      location: 'Morocco',
      dateLabel: '2025',
      description: 'African Cup hosted in Morocco.',
    ),
    MockEvent(
      title: 'Desert Music Night',
      category: 'Music',
      image: 'assets/events/music_night.jpg',
      location: 'Merzouga',
      dateLabel: 'Fri, 25 Oct · 20:30',
      description:
      'Live gnawa-style session by the dunes. Fire, drums, and a premium camp ambiance under the stars.',
    ),
    MockEvent(
      title: 'Museum Day Pass',
      category: 'Art',
      image: 'assets/events/museum_day.jpg',
      location: 'Rabat',
      dateLabel: 'Any day · 09:00—18:00',
      description:
      'Premium access to curated exhibits. Ideal for a calm day of discovery and cultural immersion.',
    ),
  ];

  static const notifications = <MockNotificationItem>[
    MockNotificationItem(
      title: 'Itinerary saved',
      message: 'Your Marrakech weekend plan is ready to review.',
      time: '2m ago',
      iconKey: 'check',
    ),
    MockNotificationItem(
      title: 'Event reminder',
      message: 'Souks Tour starts in 3 hours. Don’t forget your camera.',
      time: '1h ago',
      iconKey: 'bell',
    ),
    MockNotificationItem(
      title: 'New recommendations',
      message: 'We found 4 new destinations matching your mood.',
      time: 'Yesterday',
      iconKey: 'spark',
    ),
    MockNotificationItem(
      title: 'Profile updated',
      message: 'Your preferences were saved successfully.',
      time: '2d ago',
      iconKey: 'user',
    ),
  ];
}

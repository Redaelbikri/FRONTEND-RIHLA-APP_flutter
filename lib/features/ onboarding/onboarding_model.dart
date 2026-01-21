class OnboardingModel {
  final String title;
  final String subtitle;
  final String image;
  final String chip;

  const OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.chip,
  });

  static const items = <OnboardingModel>[
    // 1) Transport + Hotel
    OnboardingModel(
      title: 'Book transport & hotels',
      subtitle: 'Find the best routes and stays — fast, smooth, and premium.',
      image: 'assets/backgrounds/onboarding_1.jpg',
      chip: 'Booking',
    ),

    // 2) Events
    OnboardingModel(
      title: 'Discover events nearby',
      subtitle: 'Culture, music, food, and local gems — curated for you.',
      image: 'assets/backgrounds/onboarding_2.jpg',
      chip: 'Events',
    ),

    // 3) AI trip planning
    OnboardingModel(
      title: 'Plan trips with AI',
      subtitle: 'Build an itinerary in seconds with smart suggestions and flow.',
      image: 'assets/backgrounds/onboarding_3.jpg',
      chip: 'AI Planner',
    ),
  ];
}

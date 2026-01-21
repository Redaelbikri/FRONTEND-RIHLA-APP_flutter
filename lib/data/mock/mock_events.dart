import '../models/event_model.dart';

class MockEvents {
  static const items = <EventModel>[
    EventModel(
      id: 'evt_souks',
      title: 'Souks Tour',
      category: 'Culture',
      image: 'assets/events/souk_tour.jpg',
      location: 'Marrakech',
      dateLabel: 'Sat, 18 Oct · 10:00',
      description: 'Explore hidden souks with a local guide.',
    ),
    EventModel(
      id: 'evt_cooking',
      title: 'Medina Cooking Class',
      category: 'Food',
      image: 'assets/events/cooking_class.jpg',
      location: 'Fes',
      dateLabel: 'Mon, 21 Oct · 16:30',
      description: 'Hands-on workshop: tajine, zaalouk, mint tea.',
    ),
    EventModel(
      id: 'evt_music',
      title: 'Desert Music Night',
      category: 'Music',
      image: 'assets/events/music_night.jpg',
      location: 'Merzouga',
      dateLabel: 'Fri, 25 Oct · 20:30',
      description: 'Live session by the dunes under the stars.',
    ),
    EventModel(
      id: 'evt_museum',
      title: 'Museum Day Pass',
      category: 'Art',
      image: 'assets/events/museum_day.jpg',
      location: 'Rabat',
      dateLabel: 'Any day · 09:00—18:00',
      description: 'Premium access to curated exhibits.',
    ),

    // SPORT
    EventModel(
      id: 'sport_afcon',
      title: 'African Cup of Nations',
      category: 'Sport',
      image: 'assets/events/afcon.jpg',
      location: 'Morocco',
      dateLabel: '2025',
      description: 'AFCON hosted in Morocco (UI mock).',
    ),
    EventModel(
      id: 'sport_wc2030',
      title: 'FIFA World Cup 2030',
      category: 'Sport',
      image: 'assets/events/worldcup2030.jpg',
      location: 'Morocco',
      dateLabel: '2030',
      description: 'World Cup hosted by Morocco (UI mock).',
    ),
  ];
}

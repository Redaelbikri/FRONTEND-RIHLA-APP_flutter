import '../models/hotel_model.dart';

class MockHotels {
  static const items = <HotelModel>[
    HotelModel(
      id: 'htl_marr_1',
      name: 'Riad Al Warda',
      city: 'Marrakech',
      image: 'assets/hotels/riad.jpg',
      rating: 4.8,
      pricePerNight: 850,
      tag: 'Best value',
    ),
    HotelModel(
      id: 'htl_casa_1',
      name: 'Ocean View Hotel',
      city: 'Casablanca',
      image: 'assets/hotels/ocean.jpg',
      rating: 4.6,
      pricePerNight: 1200,
      tag: 'Top rated',
    ),
    HotelModel(
      id: 'htl_rabat_1',
      name: 'Royal Stay Rabat',
      city: 'Rabat',
      image: 'assets/hotels/royal.jpg',
      rating: 4.9,
      pricePerNight: 2200,
      tag: 'Luxury',
    ),
  ];
}

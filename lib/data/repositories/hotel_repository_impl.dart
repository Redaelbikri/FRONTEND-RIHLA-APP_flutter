import '../services/hotel_api.dart';
import '../models/hotel_model.dart';
import '../../features/booking/hotels/hotel_models.dart';

class HotelRepositoryImpl {
  final HotelApi _api;

  HotelRepositoryImpl(this._api);

  Future<List<Hotel>> getHotels(String city) async {
    final List<HotelModel> backendHotels =
    await _api.fetchHotels();

    final List<Hotel> mappedHotels = backendHotels.map((h) {
      return Hotel(
        name: h.nom,
        city: h.ville,
        image: h.imageUrl.isNotEmpty
            ? h.imageUrl
            : "assets/hotels/hotel_1.jpg",
        rating: h.note,
        reviewsCount: 120,
        priceMadPerNight: h.prixParNuit.toInt(),
        tags: [
          h.type,
          h.chambresDisponibles > 0
              ? "Available (${h.chambresDisponibles})"
              : "Full",
        ],
        reviews: const [],
      );
    }).toList();

    final cityTrim = city.trim();

    if (cityTrim.isEmpty) return mappedHotels;

    return mappedHotels
        .where((h) =>
        h.city.toLowerCase().contains(cityTrim.toLowerCase()))
        .toList();
  }
}

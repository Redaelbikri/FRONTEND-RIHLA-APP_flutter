import '../api/hebergements_api.dart';
import '../models/hotel_model.dart';

class HotelRepositoryImpl {
  final HebergementsApi _api;

  HotelRepositoryImpl(this._api);

  Future<List<HotelModel>> getHotels(String city) async {
    final cityTrim = city.trim();

    // Backend filter: ?city=
    final backendHotels = await _api.fetchHebergements(
      city: cityTrim.isEmpty ? null : cityTrim,
    );

    // Ici on retourne DIRECT HotelModel (pas de mapping vers "Hotel" inexistant)
    return backendHotels;
  }
}

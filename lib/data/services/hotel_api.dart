import '../models/hotel_model.dart';
import 'api_client.dart';

class HotelApi {
  final _client = ApiClient().dio;

  /// 🔹 Récupérer tous les hébergements
  Future<List<HotelModel>> fetchHotels() async {
    final res = await _client.get("/api/hebergements");

    return (res.data as List)
        .map((e) => HotelModel.fromJson(e))
        .toList();
  }

  /// 🔹 Filtrer par type (endpoint backend existant)
  Future<List<HotelModel>> fetchByType(String type) async {
    final res = await _client.get(
      "/api/hebergements/filter/type/$type",
    );

    return (res.data as List)
        .map((e) => HotelModel.fromJson(e))
        .toList();
  }

  /// 🔹 Récupérer un hébergement par ID
  Future<HotelModel> fetchHotelById(int id) async {
    final res = await _client.get("/api/hebergements/$id");
    return HotelModel.fromJson(res.data);
  }
}

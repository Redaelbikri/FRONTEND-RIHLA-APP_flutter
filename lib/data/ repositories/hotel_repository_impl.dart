import '../models/hotel_model.dart';

abstract class HotelRepository {
  Future<List<HotelModel>> getHotels({DateTime? checkIn, DateTime? checkOut, String? city});
}

import '../mock/mock_hotels.dart';
import '../models/hotel_model.dart';
import 'hotel_repository.dart';

class MockHotelRepository implements HotelRepository {
  @override
  Future<List<HotelModel>> getHotels({DateTime? checkIn, DateTime? checkOut, String? city}) async {
    await Future.delayed(const Duration(milliseconds: 240));
    final all = MockHotels.items;
    if (city == null || city.trim().isEmpty) return all;
    return all.where((h) => h.city.toLowerCase() == city.toLowerCase()).toList();
  }
}

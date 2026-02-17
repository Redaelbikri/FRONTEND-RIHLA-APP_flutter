import '../api/trips_api.dart';
import '../models/trip_model.dart';

class TripsRepository {
  final TripsApi _api;
  TripsRepository(this._api);

  Future<List<TripModel>> searchTrips({
    required String fromCity,
    required String toCity,
    required DateTime date,
    required String type,
  }) {
    final d = '${date.year.toString().padLeft(4,'0')}-'
        '${date.month.toString().padLeft(2,'0')}-'
        '${date.day.toString().padLeft(2,'0')}';
    return _api.search(fromCity: fromCity, toCity: toCity, date: d, type: type);
  }
}

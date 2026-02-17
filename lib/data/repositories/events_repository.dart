import '../api/events_api.dart';
import '../models/event_model.dart';

class EventsRepository {
  final EventsApi _api;
  EventsRepository(this._api);

  Future<List<EventModel>> list({String? category}) {
    if (category == null || category == 'All') return _api.getAll();

    // Your UI uses: Culture/Food/Music/Art/Nature/Sport
    // Backend expects category string match stored values.
    return _api.filterByCategory(category);
  }
}

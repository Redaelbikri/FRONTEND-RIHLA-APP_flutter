import '../models/event_model.dart';
import 'api_client.dart';

class EventApi {
  final _client = ApiClient().dio;

  Future<List<EventModel>> getAllEvents() async {
    final response = await _client.get("/api/events");

    return (response.data as List)
        .map((e) => EventModel.fromJson(e))
        .toList();
  }

  Future<EventModel> getEventById(int id) async {
    final response = await _client.get("/api/events/$id");
    return EventModel.fromJson(response.data);
  }
}

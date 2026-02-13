import '../models/event_model.dart';

abstract class EventRepository {
  Future<List<EventModel>> getEvents();
  Future<List<EventModel>> getEventsByCategory(String category);
}

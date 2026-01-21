import '../mock/mock_events.dart';
import '../models/event_model.dart';
import 'event_repository.dart';

class MockEventRepository implements EventRepository {
  @override
  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 220));
    return MockEvents.items;
  }

  @override
  Future<List<EventModel>> getEventsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 220));
    if (category == 'All') return MockEvents.items;
    return MockEvents.items.where((e) => e.category == category).toList();
  }
}

import '../mock/mock_transports.dart';
import '../models/transport_model.dart';
import 'transport_repository.dart';

class MockTransportRepository implements TransportRepository {
  @override
  Future<List<TransportOptionModel>> search({
    required String fromCity,
    required String toCity,
    required DateTime date,
    TransportType? type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 260));
    final from = fromCity.trim().toLowerCase();
    final to = toCity.trim().toLowerCase();

    var res = MockTransports.items.where((t) =>
    t.fromCity.toLowerCase() == from && t.toCity.toLowerCase() == to);

    if (type != null) {
      res = res.where((t) => t.type == type);
    }

    return res.toList();
  }
}

import '../models/transport_model.dart';

abstract class TransportRepository {
  Future<List<TransportOptionModel>> search({
    required String fromCity,
    required String toCity,
    required DateTime date,
    TransportType? type,
  });
}

import 'api_client.dart';

class ReservationApi {
  final _client = ApiClient().dio;

  Future<void> createReservation({
    required int eventId,
    required int quantity,
  }) async {
    await _client.post(
      "/api/reservations",
      data: {
        "eventId": eventId,
        "quantity": quantity,
      },
    );
  }
}

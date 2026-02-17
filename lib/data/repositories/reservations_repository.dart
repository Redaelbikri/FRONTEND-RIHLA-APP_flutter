import '../api/reservations_api.dart';
import '../models/reservation_model.dart';

class ReservationsRepository {
  final ReservationsApi _api;
  ReservationsRepository(this._api);

  Future<ReservationModel> reserveEvent({required String eventId, required int quantity}) {
    return _api.create(eventId: eventId, eventQty: quantity);
  }

  Future<ReservationModel> reserveHotel({required String hebergementId, required int rooms}) {
    return _api.create(hebergementId: hebergementId, hebergementQty: rooms);
  }

  Future<ReservationModel> reserveTrip({required String tripId, required int seats}) {
    return _api.create(transportId: tripId, transportQty: seats);
  }
}

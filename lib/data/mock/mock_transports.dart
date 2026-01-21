import '../models/transport_model.dart';

class MockTransports {
  static const items = <TransportOptionModel>[
    TransportOptionModel(
      id: 'tr_oncf_1',
      type: TransportType.train,
      fromCity: 'Casablanca',
      toCity: 'Rabat',
      departTime: '08:10',
      arriveTime: '09:20',
      price: 65,
      provider: 'ONCF',
    ),
    TransportOptionModel(
      id: 'tr_ctm_1',
      type: TransportType.bus,
      fromCity: 'Marrakech',
      toCity: 'Agadir',
      departTime: '10:00',
      arriveTime: '13:30',
      price: 120,
      provider: 'CTM',
    ),
    TransportOptionModel(
      id: 'tr_plane_1',
      type: TransportType.plane,
      fromCity: 'Tanger',
      toCity: 'Marrakech',
      departTime: '12:15',
      arriveTime: '13:35',
      price: 650,
      provider: 'Airline',
    ),
  ];
}

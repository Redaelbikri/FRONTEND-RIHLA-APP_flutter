enum TransportType { plane, car, train, bus }

class TransportOptionModel {
  final String id;
  final TransportType type;
  final String fromCity;
  final String toCity;
  final String departTime; // "08:30"
  final String arriveTime; // "11:10"
  final int price; // MAD
  final String provider; // ONCF, CTM, Airline...

  const TransportOptionModel({
    required this.id,
    required this.type,
    required this.fromCity,
    required this.toCity,
    required this.departTime,
    required this.arriveTime,
    required this.price,
    required this.provider,
  });

  static TransportType typeFromString(String v) {
    switch (v.toLowerCase()) {
      case 'plane':
        return TransportType.plane;
      case 'car':
        return TransportType.car;
      case 'train':
        return TransportType.train;
      case 'bus':
        return TransportType.bus;
      default:
        return TransportType.train;
    }
  }

  static String typeToString(TransportType t) => t.name;

  factory TransportOptionModel.fromJson(Map<String, dynamic> json) => TransportOptionModel(
    id: (json['id'] ?? '').toString(),
    type: typeFromString((json['type'] ?? 'train').toString()),
    fromCity: (json['fromCity'] ?? '').toString(),
    toCity: (json['toCity'] ?? '').toString(),
    departTime: (json['departTime'] ?? '').toString(),
    arriveTime: (json['arriveTime'] ?? '').toString(),
    price: (json['price'] ?? 0) as int,
    provider: (json['provider'] ?? '').toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': typeToString(type),
    'fromCity': fromCity,
    'toCity': toCity,
    'departTime': departTime,
    'arriveTime': arriveTime,
    'price': price,
    'provider': provider,
  };
}

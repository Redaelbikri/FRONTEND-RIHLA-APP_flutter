class TripModel {
  final String id;
  final String fromCity;
  final String toCity;
  final DateTime? departureAt;
  final DateTime? arrivalAt;
  final String type; // enum BUS/TRAIN/TAXI/FLIGHT
  final String currency;
  final double price;
  final int capacity;
  final int availableSeats;
  final String providerName;

  TripModel({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.departureAt,
    required this.arrivalAt,
    required this.type,
    required this.currency,
    required this.price,
    required this.capacity,
    required this.availableSeats,
    required this.providerName,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: (json['id'] ?? '').toString(),
      fromCity: (json['fromCity'] ?? '').toString(),
      toCity: (json['toCity'] ?? '').toString(),
      departureAt: DateTime.tryParse((json['departureAt'] ?? '').toString()),
      arrivalAt: DateTime.tryParse((json['arrivalAt'] ?? '').toString()),
      type: (json['type'] ?? '').toString(),
      currency: (json['currency'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
      providerName: (json['providerName'] ?? '').toString(),
    );
  }
}

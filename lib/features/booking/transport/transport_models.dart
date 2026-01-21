import 'package:flutter/material.dart';
import 'transport_mode.dart';

enum SortFilter { all, fastest, cheapest }

extension SortFilterX on SortFilter {
  String get label {
    switch (this) {
      case SortFilter.all:
        return 'All';
      case SortFilter.fastest:
        return 'Fastest';
      case SortFilter.cheapest:
        return 'Cheapest';
    }
  }
}

class TransportResult {
  final TransportMode mode;
  final String brand;
  final String operatorName;
  final String meta;
  final String badge;
  final TimeOfDay depart;
  final TimeOfDay arrive;
  final String fromStation;
  final String toStation;
  final Duration duration;
  final int priceMad;
  final List<String> perks;
  final IconData icon;

  const TransportResult({
    required this.mode,
    required this.brand,
    required this.operatorName,
    required this.meta,
    required this.badge,
    required this.depart,
    required this.arrive,
    required this.fromStation,
    required this.toStation,
    required this.duration,
    required this.priceMad,
    required this.perks,
    required this.icon,
  });
}

class TransportMock {
  static List<TransportResult> resultsFor(TransportMode mode) {
    switch (mode) {
      case TransportMode.train:
        return _train;
      case TransportMode.bus:
        return _bus;
      case TransportMode.flight:
        return _flight;
      case TransportMode.car:
        return _car;
    }
  }

  static final _train = <TransportResult>[
    TransportResult(
      mode: TransportMode.train,
      brand: 'Al Boraq',
      operatorName: 'ONCF',
      meta: 'High Speed',
      badge: 'FASTEST',
      depart: const TimeOfDay(hour: 9, minute: 0),
      arrive: const TimeOfDay(hour: 11, minute: 10),
      fromStation: 'Casa Voyageurs',
      toStation: 'Tanger Ville',
      duration: const Duration(hours: 2, minutes: 10),
      priceMad: 249,
      perks: const ['Free WiFi', 'Power'],
      icon: Icons.train_rounded,
    ),
    TransportResult(
      mode: TransportMode.train,
      brand: 'Atlas Train',
      operatorName: 'ONCF',
      meta: 'Regular',
      badge: '',
      depart: const TimeOfDay(hour: 10, minute: 15),
      arrive: const TimeOfDay(hour: 15, minute: 0),
      fromStation: 'Casa Port',
      toStation: 'Tanger Ville',
      duration: const Duration(hours: 4, minutes: 45),
      priceMad: 135,
      perks: const ['Comfort'],
      icon: Icons.train_rounded,
    ),
  ];

  static final _bus = <TransportResult>[
    TransportResult(
      mode: TransportMode.bus,
      brand: 'CTM',
      operatorName: 'CTM',
      meta: 'Direct',
      badge: 'ECONOMY',
      depart: const TimeOfDay(hour: 9, minute: 45),
      arrive: const TimeOfDay(hour: 14, minute: 30),
      fromStation: 'Casa CTM',
      toStation: 'Tanger CTM',
      duration: const Duration(hours: 4, minutes: 45),
      priceMad: 110,
      perks: const ['AC', 'WiFi'],
      icon: Icons.directions_bus_rounded,
    ),
    TransportResult(
      mode: TransportMode.bus,
      brand: 'Supratours',
      operatorName: 'ONCF',
      meta: 'Comfort',
      badge: '',
      depart: const TimeOfDay(hour: 11, minute: 0),
      arrive: const TimeOfDay(hour: 16, minute: 30),
      fromStation: 'Casa Supratours',
      toStation: 'Tanger',
      duration: const Duration(hours: 5, minutes: 30),
      priceMad: 95,
      perks: const ['AC'],
      icon: Icons.directions_bus_rounded,
    ),
  ];

  static final _flight = <TransportResult>[
    TransportResult(
      mode: TransportMode.flight,
      brand: 'Royal Air Maroc',
      operatorName: 'RAM',
      meta: 'Non-stop',
      badge: 'FASTEST',
      depart: const TimeOfDay(hour: 8, minute: 30),
      arrive: const TimeOfDay(hour: 9, minute: 25),
      fromStation: 'CMN',
      toStation: 'TNG',
      duration: const Duration(minutes: 55),
      priceMad: 620,
      perks: const ['Cabin bag', 'Priority'],
      icon: Icons.flight_rounded,
    ),
    TransportResult(
      mode: TransportMode.flight,
      brand: 'Air Arabia',
      operatorName: 'Air Arabia',
      meta: 'Non-stop',
      badge: 'CHEAP',
      depart: const TimeOfDay(hour: 15, minute: 10),
      arrive: const TimeOfDay(hour: 16, minute: 10),
      fromStation: 'CMN',
      toStation: 'TNG',
      duration: const Duration(hours: 1),
      priceMad: 399,
      perks: const ['Cabin bag'],
      icon: Icons.flight_rounded,
    ),
  ];

  static final _car = <TransportResult>[
    TransportResult(
      mode: TransportMode.car,
      brand: 'Comfort Ride',
      operatorName: 'Partner',
      meta: 'Private',
      badge: 'PREMIUM',
      depart: const TimeOfDay(hour: 9, minute: 0),
      arrive: const TimeOfDay(hour: 13, minute: 30),
      fromStation: 'Casablanca',
      toStation: 'Tanger',
      duration: const Duration(hours: 4, minutes: 30),
      priceMad: 890,
      perks: const ['Door-to-door', 'AC'],
      icon: Icons.directions_car_rounded,
    ),
    TransportResult(
      mode: TransportMode.car,
      brand: 'Shared Ride',
      operatorName: 'Partner',
      meta: 'Shared',
      badge: 'CHEAP',
      depart: const TimeOfDay(hour: 10, minute: 0),
      arrive: const TimeOfDay(hour: 15, minute: 0),
      fromStation: 'Casablanca',
      toStation: 'Tanger',
      duration: const Duration(hours: 5),
      priceMad: 240,
      perks: const ['Meet-up point'],
      icon: Icons.directions_car_rounded,
    ),
  ];
}

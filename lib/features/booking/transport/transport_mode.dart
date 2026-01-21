enum TransportMode { train, bus, flight, car }

extension TransportModeX on TransportMode {
  String get label {
    switch (this) {
      case TransportMode.train:
        return 'Trains';
      case TransportMode.bus:
        return 'Buses';
      case TransportMode.flight:
        return 'Flights';
      case TransportMode.car:
        return 'Cars';
    }
  }

  int get index {
    switch (this) {
      case TransportMode.train:
        return 0;
      case TransportMode.bus:
        return 1;
      case TransportMode.flight:
        return 2;
      case TransportMode.car:
        return 3;
    }
  }
}

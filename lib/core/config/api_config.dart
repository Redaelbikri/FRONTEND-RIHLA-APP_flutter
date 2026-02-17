class ApiConfig {
  /// Android emulator → 10.0.2.2
  /// Real device → your PC IP on same Wi-Fi (e.g. 192.168.1.20)
  static const String emulatorBaseUrl = 'http://10.0.2.2:8080';
  static const String deviceBaseUrl = 'http://10.178.210.140:8080';

  /// Flip this when you test on real phone
  static const bool useEmulator = false;

  static String get baseUrl => useEmulator ? emulatorBaseUrl : deviceBaseUrl;

  /// Keys (must be stable)
  static const tokenKey = 'token';
}

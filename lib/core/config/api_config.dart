class ApiConfig {
  static const String emulatorBaseUrl = 'http://10.0.2.2:8080';
  static const String deviceBaseUrl = 'http://10.92.169.140:8080';

  // ✅ real phone
  static const bool useEmulator = false;

  static String get baseUrl => useEmulator ? emulatorBaseUrl : deviceBaseUrl;

  static const tokenKey = 'token';
}

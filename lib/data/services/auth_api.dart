import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthApi {
  final _client = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  static String? _token;

  String? get token => _token;

  Future<void> loadToken() async {
    _token = await _storage.read(key: "token");
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await _client.post(
        "/api/auth/signin",
        data: {
          "username": username,
          "password": password,
        },
      );

      _token = response.data["jwt"];
      await _storage.write(key: "token", value: _token);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: "token");
  }

  bool get isLoggedIn => _token != null;
}

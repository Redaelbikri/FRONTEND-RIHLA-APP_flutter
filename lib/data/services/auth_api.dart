import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/config/api_config.dart';
import 'api_client.dart';

class AuthSession {
  final String token;
  final String id;
  final String email;
  final List<String> roles;

  const AuthSession({
    required this.token,
    required this.id,
    required this.email,
    required this.roles,
  });

  bool get isAdmin => roles.contains('ROLE_ADMIN');
}

class UserMe {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;

  const UserMe({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
  });

  factory UserMe.fromJson(Map<String, dynamic> json) {
    return UserMe(
      id: (json['id'] ?? '').toString(),
      nom: (json['nom'] ?? '').toString(),
      prenom: (json['prenom'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      telephone: json['telephone']?.toString(),
    );
  }
}

class AuthApi {
  AuthApi._internal() {
    // auto logout on 401 from ApiClient interceptor
    ApiClient().setUnauthorizedHandler(() async {
      await logout();
    });
  }

  static final AuthApi _instance = AuthApi._internal();
  factory AuthApi() => _instance;

  final Dio _dio = ApiClient().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthSession? _session;
  AuthSession? get session => _session;

  bool get isLoggedIn => (_session?.token.isNotEmpty ?? false);

  Future<void> loadToken() async {
    final token = await _storage.read(key: ApiConfig.tokenKey);
    if (token != null && token.trim().isNotEmpty) {
      _session = AuthSession(token: token.trim(), id: '', email: '', roles: const []);
    }
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '/api/auth/signin',
        data: {'email': email, 'password': password},
      );

      final data = (res.data as Map).cast<String, dynamic>();

      final token = (data['token'] ?? '').toString().trim();
      final id = (data['id'] ?? '').toString();
      final emailResp = (data['email'] ?? '').toString();
      final rolesRaw = data['roles'];
      final roles = (rolesRaw is List) ? rolesRaw.map((e) => e.toString()).toList() : <String>[];

      if (token.isEmpty) throw ApiException(message: 'Login failed: missing token');

      await _storage.write(key: ApiConfig.tokenKey, value: token);

      _session = AuthSession(token: token, id: id, email: emailResp, roles: roles);
      return _session!;
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<void> signup({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    String? telephone,
  }) async {
    try {
      await _dio.post(
        '/api/auth/signup',
        data: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
          if (telephone != null && telephone.trim().isNotEmpty) 'telephone': telephone.trim(),
        },
        options: Options(responseType: ResponseType.plain),
      );
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<UserMe> me() async {
    try {
      final res = await _dio.get('/api/users/me');
      return UserMe.fromJson((res.data as Map).cast<String, dynamic>());
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<UserMe> updateMe({
    required String nom,
    required String prenom,
    String? telephone,
  }) async {
    try {
      final res = await _dio.put(
        '/api/users/me',
        data: {
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
        },
      );
      return UserMe.fromJson((res.data as Map).cast<String, dynamic>());
    } on DioException catch (e) {
      throw ApiClient().mapDioError(e);
    }
  }

  Future<void> logout() async {
    _session = null;
    await _storage.delete(key: ApiConfig.tokenKey);
  }
}

import 'package:flutter/material.dart';
import 'app.dart';
import 'data/services/auth_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthApi().loadToken();

  runApp(const RihlaApp());
}

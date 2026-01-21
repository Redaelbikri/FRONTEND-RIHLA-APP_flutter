import 'package:flutter/material.dart';
import 'core/nav/app_router.dart';
import 'core/theme/rihla_theme.dart';

class RihlaApp extends StatelessWidget {
  const RihlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIHLA',
      debugShowCheckedModeBanner: false,
      theme: RihlaTheme.light(),
      darkTheme: RihlaTheme.dark(),
      themeMode: ThemeMode.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: Routes.splash,
    );
  }
}

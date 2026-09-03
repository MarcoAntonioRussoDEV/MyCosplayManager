import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'auth/auth_service.dart';
import 'auth/login_page.dart';
import 'core/locale_controller.dart';
import 'home/home_page.dart';
import 'l10n/app_localizations.dart';

class CosplayInventoryApp extends StatefulWidget {
  const CosplayInventoryApp({super.key});

  @override
  State<CosplayInventoryApp> createState() => _CosplayInventoryAppState();
}

class _CosplayInventoryAppState extends State<CosplayInventoryApp> {
  final _authService = AuthService();
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _authService.restoreSession();
    _localeController.restore();
  }

  @override
  void dispose() {
    _authService.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authService),
        ChangeNotifierProvider.value(value: _localeController),
      ],
      child: Consumer2<AuthService, LocaleController>(
        builder: (context, auth, locale, _) {
          return MaterialApp(
            title: 'Cosplay Inventory',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
            locale: locale.override,
            supportedLocales: supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: !auth.initialized
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : (auth.isLoggedIn ? const HomePage() : const LoginPage()),
          );
        },
      ),
    );
  }
}

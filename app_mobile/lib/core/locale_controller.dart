import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const supportedLocales = [Locale('it'), Locale('en'), Locale('es'), Locale('fr')];

/// null = segui la lingua del dispositivo (se supportata, altrimenti italiano di fallback).
class LocaleController extends ChangeNotifier {
  static const _key = 'locale_override';
  final _secureStorage = const FlutterSecureStorage();
  Locale? _override;

  Locale? get override => _override;

  Future<void> restore() async {
    final saved = await _secureStorage.read(key: _key);
    if (saved != null) {
      _override = Locale(saved);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _override = locale;
    if (locale == null) {
      await _secureStorage.delete(key: _key);
    } else {
      await _secureStorage.write(key: _key, value: locale.languageCode);
    }
    notifyListeners();
  }
}

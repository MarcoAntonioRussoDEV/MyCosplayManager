import 'package:firebase_messaging/firebase_messaging.dart';

import 'api_client.dart';

/// Registra il token FCM del dispositivo sul backend dopo il login, cosi' note
/// progetto/alert scadenza possono arrivare come push reali (vedi
/// DeviceTokenController lato backend). Il contenuto della notifica lo mostra
/// il sistema operativo da solo: qui c'e' solo la registrazione del token.
class PushNotificationService {
  final ApiClient _apiClient;
  String? _registeredToken;

  PushNotificationService(this._apiClient);

  Future<void> registerDevice() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    final token = await messaging.getToken();
    if (token != null) await _register(token);

    messaging.onTokenRefresh.listen(_register);
  }

  Future<void> _register(String token) async {
    if (token == _registeredToken) return;
    try {
      await _apiClient.post('/api/device-tokens', body: {'fcmToken': token, 'platform': 'android'});
      _registeredToken = token;
    } catch (_) {
      // Non critico: se fallisce si ritenta al prossimo login/refresh token.
    }
  }

  Future<void> unregisterDevice() async {
    final token = _registeredToken;
    if (token == null) return;
    try {
      await _apiClient.delete('/api/device-tokens/$token');
    } catch (_) {
      // Non critico.
    }
    _registeredToken = null;
  }
}

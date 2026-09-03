import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/api_client.dart';

class AuthUser {
  final String userId;
  final String email;
  final String name;
  final String teamId;

  AuthUser({required this.userId, required this.email, required this.name, required this.teamId});

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        userId: json['userId'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        teamId: json['teamId'] as String,
      );
}

/// Unico metodo di login dell'app: Google OAuth. Il JWT restituito dal backend
/// viene salvato in secure storage e riusato finche' non scade o l'utente esce.
class AuthService extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  final _secureStorage = const FlutterSecureStorage();
  // Client OAuth "Web" (Google Cloud Console), non quello Android: e' l'audience che il
  // backend verifica in GoogleTokenVerifierService. Serve anche se si accede da Android.
  final _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID'),
  );
  late final ApiClient _apiClient;

  String? _token;
  AuthUser? _currentUser;
  bool _initialized = false;

  AuthService() {
    _apiClient = ApiClient(tokenProvider: () async => _token, onUnauthorized: () async => await signOut());
  }

  bool get isLoggedIn => _token != null;
  bool get initialized => _initialized;
  AuthUser? get currentUser => _currentUser;
  ApiClient get apiClient => _apiClient;

  Future<void> restoreSession() async {
    _token = await _secureStorage.read(key: _tokenKey);
    _initialized = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return; // utente ha annullato il picker
    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('Google non ha restituito un ID token');
    }

    final response = await _apiClient.post('/api/auth/google', body: {'idToken': idToken});
    _token = response['token'] as String;
    _currentUser = AuthUser.fromJson(response as Map<String, dynamic>);
    await _secureStorage.write(key: _tokenKey, value: _token);
    notifyListeners();
  }

  Future<void> signOut() async {
    _token = null;
    _currentUser = null;
    await _secureStorage.delete(key: _tokenKey);
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // non critico: il logout locale (token rimosso) e' gia' avvenuto.
    }
    notifyListeners();
  }
}

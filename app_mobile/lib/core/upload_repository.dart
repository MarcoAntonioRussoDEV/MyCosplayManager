import 'dart:io';

import 'api_client.dart';

class UploadRepository {
  final ApiClient _apiClient;

  UploadRepository(this._apiClient);

  /// Carica una foto (prodotto/progetto) e torna l'URL relativo da salvare come imageUrl.
  Future<String> uploadImage(File file) async {
    final extension = file.path.split('.').last.toLowerCase();
    final contentType = switch (extension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final json = await _apiClient.postMultipart('/api/uploads', file, contentType);
    return json['url'] as String;
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveApiToken(String token) async {
    await _storage.write(key: 'api_token', value: token);
  }

  Future<String?> getApiToken() async {
    return await _storage.read(key: 'api_token');
  }

  Future<void> deleteApiToken() async {
    await _storage.delete(key: 'api_token');
  }
}
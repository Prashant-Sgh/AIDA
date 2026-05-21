import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

class SecureStorageService {
  static const _secureStorage = FlutterSecureStorage();

  static const _jwtKey = 'jwtKey';

  Future<void> saveJwt({required String jwtToken}) async {
    await _secureStorage.write(key: _jwtKey, value: jwtToken);
  }

  Future<String?> getJwt() async {
    return await _secureStorage.read(key: _jwtKey);
  }

  Future<void> clearJwt() async {
    await _secureStorage.delete(key: _jwtKey);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
final Uuid _uuid = const Uuid();

const String _deviceIdKey = 'device_uuid';
const String _jwtKey = 'jwt';

class AuthData {
  final String deviceId;
  String? jwt;

  AuthData(this.deviceId, this.jwt);
}

final AndroidOptions _androidOptions = const AndroidOptions(
  encryptedSharedPreferences: true,
);

Future<String> getOrCreateDeviceId() async {
  final String? existing = await _secureStorage.read(
    key: _deviceIdKey,
    aOptions: _androidOptions,
  );

  if (existing != null && existing.isNotEmpty) return existing;

  final String newId = _uuid.v4();

  await _secureStorage.write(
    key: _deviceIdKey,
    value: newId,
    aOptions: _androidOptions,
  );

  return newId;
}

Future<AuthData> getOrCreateAuthData() async {
  String? deviceId = await _secureStorage.read(
    key: _deviceIdKey,
    aOptions: _androidOptions,
  );

  final String? jwt = await _secureStorage.read(
    key: _jwtKey,
    aOptions: _androidOptions,
  );

  if (deviceId != null && deviceId.isNotEmpty) {
    return AuthData(deviceId, jwt);
  }

  deviceId = _uuid.v4();

  await _secureStorage.write(
    key: _deviceIdKey,
    value: deviceId,
    aOptions: _androidOptions,
  );

  return AuthData(deviceId, jwt);
}

Future<void> clearDeviceId() async {
  await _secureStorage.delete(key: _deviceIdKey, aOptions: _androidOptions);
}

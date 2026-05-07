import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

// خدمة المصادقة - تدعم بصمة الإصبع و PIN
// تستخدم flutter_secure_storage لحفظ PIN مشفّراً

class AuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // التحقق من توفر البصمة على الجهاز
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (e) {
      return false;
    }
  }

  // المصادقة ببصمة الإصبع
  Future<bool> authenticateWithBiometric({
    required String reason,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // تشفير PIN باستخدام SHA-256
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // حفظ PIN جديد
  Future<void> setPin(String pin) async {
    final hashedPin = _hashPin(pin);
    await _secureStorage.write(key: AppConstants.pinHashKey, value: hashedPin);
  }

  // التحقق من PIN
  Future<bool> verifyPin(String pin) async {
    final storedHash =
        await _secureStorage.read(key: AppConstants.pinHashKey);
    if (storedHash == null) return false;
    final hashedPin = _hashPin(pin);
    return storedHash == hashedPin;
  }

  // التحقق من وجود PIN
  Future<bool> hasPinSet() async {
    final pin = await _secureStorage.read(key: AppConstants.pinHashKey);
    return pin != null && pin.isNotEmpty;
  }

  // إزالة PIN
  Future<void> removePin() async {
    await _secureStorage.delete(key: AppConstants.pinHashKey);
  }
}

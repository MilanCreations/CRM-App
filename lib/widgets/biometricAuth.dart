import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();
      var available = await auth.getAvailableBiometrics();

      if (!canCheck || !isSupported || available.isEmpty) {
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Unlock to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      print("Biometric Auth Error: $e");
      return false;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AuthState with ChangeNotifier{
  final LocalAuthentication auth = LocalAuthentication();
  SupportState _supportState = SupportState.unknown;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  String _authorized = 'No autorizado';
  bool _isAuthenticating = false;
  String _supported = "No soportado";


  bool canCheckBiometris() => _canCheckBiometrics;
  List<BiometricType> availableBiometrics()=> _availableBiometrics;
  SupportState supportState()=>_supportState;
  String authorized()=>_authorized;
  bool isAuthenticating() => _isAuthenticating;
  String stringSupported() =>_supported;

  Future<void> deviceSupport() async {
    bool isSupported = await auth.isDeviceSupported();
    isSupported ? _supportState= SupportState.supported : _supportState=SupportState.unsupported;
    print(_supportState);
    notifyListeners();
  }

  Future<void> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      print(canCheckBiometrics);
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    _canCheckBiometrics = canCheckBiometrics;
    notifyListeners();
  }

  Future<void> getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }

    _availableBiometrics = availableBiometrics;
    print(_availableBiometrics);
    notifyListeners();
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      _isAuthenticating = true;
        _authorized = 'Authenticating';

      authenticated = await auth.authenticate(
          localizedReason: 'Biometric authentication of the device',
          useErrorDialogs: true,
          stickyAuth: true);

      _isAuthenticating = false;
    } on PlatformException catch (e) {
      print(e);

        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";

      return;
    }

    _authorized = authenticated ? 'Autorized' : 'Not Autorized';
    notifyListeners();
  }

Future<void> authenticateWithBiometrics() async {
  bool authenticated = false;
  try {
    _isAuthenticating = true;
    _authorized = 'Authenticating';
    notifyListeners();

      authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint or face to continue',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);

    _isAuthenticating = false;
    _authorized = 'Authenticating';

    notifyListeners();
  } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      _authorized = "Error - ${e.message}";
      return;
    }


    final String message = authenticated ? 'Authorized' : 'Not Authorized';
  _authorized = message;
  notifyListeners();
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    await Future.delayed(Duration(milliseconds: 20));
    notifyListeners();
  }


}

enum SupportState {
  unknown,
  supported,
  unsupported,
}

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ConfigSecurity extends StatefulWidget {
  const ConfigSecurity({Key? key}) : super(key: key);

  @override
  _ConfigSecurityState createState() => _ConfigSecurityState();
}

class _ConfigSecurityState extends State<ConfigSecurity> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() =>
              _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Haz iniciado esta aplicación sin seguridad. \n¿Deseas activar la autenticación biométrica?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          ),

        ],
      )),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

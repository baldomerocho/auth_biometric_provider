import 'package:auth_bio/provider/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>(
        create: (_) => AuthState(),
        builder: (context, child) {
          return MyApp();
        });
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var prov = Provider.of<AuthState>(context, listen: false);
    prov.checkBiometrics();
    prov.deviceSupport();
    prov.getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<AuthState>(context, listen: false);
    var provL = Provider.of<AuthState>(context);

    return CupertinoApp(
        home: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Biometric Authentication test'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provL.supportState() == SupportState.unknown)
                  CircularProgressIndicator()
                else if (provL.supportState() == SupportState.supported)
                  Text("This device is compatible")
                else
                  Text("this device is not supported"),
                Divider(height: 100),
                Text('can this device check biometric factors?: ${provL.canCheckBiometris()}\n'),
                CupertinoButton(
                  color: CupertinoColors.activeOrange,
                  child: const Text('Check Biometric'),
                  onPressed: () {
                    prov.checkBiometrics();
                  },
                ),
                Divider(height: 100),
                Text('Current state: ${provL.authorized()}\n'),
                (provL.isAuthenticating())
                    ? CupertinoButton(
                        color: CupertinoColors.systemPink,
                        onPressed: () {
                          prov.cancelAuthentication();
                        },
                        child: Text("Cancelar autenticación"),
                      )
                    : Column(
                        children: [
                          CupertinoButton(
                            color: CupertinoColors.systemGreen,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Auth with out state'),
                                Icon(CupertinoIcons.device_phone_portrait),
                              ],
                            ),
                            onPressed: () {
                              prov.authenticate();
                            },
                          ),
                          Divider(),
                          CupertinoButton(
                            color: CupertinoColors.activeGreen,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(provL.isAuthenticating() ? 'Cancelar' : 'Auth with state'),
                                Icon(Icons.fingerprint),
                              ],
                            ),
                            onPressed: () {
                              prov.authenticateWithBiometrics();
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

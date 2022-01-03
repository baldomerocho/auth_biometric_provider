// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:auth_bio/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>(
      create: (_)=>AuthState(),
        child: MyApp());
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric Authentication Devel'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provL.supportState() == SupportState.unknown)
                  CircularProgressIndicator()
                else if (provL.supportState() == SupportState.supported)
                  Text("Este dispositivo es apto")
                else
                  Text("Este dispositivo no es apto, se procedería a pedir patron o contraseña"),
                Divider(height: 100),
                Text('Puede comprobar la biometría: ${provL.canCheckBiometris()}\n'),
                ElevatedButton(
                  child: const Text('Verificar biometría'),
                  onPressed: (){
                    prov.checkBiometrics();
                  },
                ),
                Divider(height: 100),
                Text('Estado actual: ${provL.authorized()}\n'),
                (provL.isAuthenticating())
                    ? ElevatedButton(
                        onPressed: (){
                          prov.cancelAuthentication();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Cancelar autenticación"),
                            Icon(Icons.cancel),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Autenticar'),
                                Icon(Icons.perm_device_information),
                              ],
                            ),
                            onPressed: (){
                              prov.authenticate();
                            },
                          ),
                          ElevatedButton(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    provL.isAuthenticating() ? 'Cancelar' : 'Autenticación: unicamente biométrica'),
                                Icon(Icons.fingerprint),
                              ],
                            ),
                            onPressed: (){
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
    );
  }
}


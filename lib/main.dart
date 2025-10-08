import 'package:flutter/material.dart';
import 'package:link_class_mobile/services/sign_in_with_google.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'services/device_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final AuthData authData = await getOrCreateAuthData();

  final String deviceId = await getOrCreateDeviceId();

  runApp(MyApp(deviceId: deviceId));
}

class MyApp extends StatelessWidget {
  final String deviceId;
  const MyApp({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(deviceId: deviceId),
    );
  }
}

class LoginPage extends StatelessWidget {
  final String deviceId;
  const LoginPage({super.key, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link Class Unipar'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              Buttons.google,
              onPressed: () => signInWithGoogle(context, deviceId),
            ),
          ],
        ),
      ),
    );
  }
}

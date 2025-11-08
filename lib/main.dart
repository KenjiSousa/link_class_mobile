import 'package:flutter/material.dart';
import 'package:link_class_mobile/logos.dart';
import 'package:link_class_mobile/services/sign_in_with_google.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'services/device_id.dart';

String? deviceId;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final AuthData authData = await getOrCreateAuthData();

  deviceId = await getOrCreateDeviceId();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link Class Unipar'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoUnipar(),
            const SizedBox(height: 100),
            const Text("Utilize sua conta da Unipar"),
            SignInButton(
              Buttons.google,
              onPressed: () => signInWithGoogle(context),
            ),
          ],
        ),
      ),
    );
  }
}

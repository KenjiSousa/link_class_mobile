import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:link_class_mobile/auth_token.dart';
import 'package:link_class_mobile/menu.dart';
import 'package:link_class_mobile/util/error_msg.dart';

Future<void> signInWithGoogle(BuildContext context, String deviceId) async {
  try {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '42851321777-1tpjtassb4vqfkp61stv6287flq6iejl.apps.googleusercontent.com',
    );

    final GoogleSignInAccount account = await GoogleSignIn.instance
        .authenticate(scopeHint: ['email', 'profile']);

    final GoogleSignInAuthentication auth = account.authentication;

    final response = await http.post(
      Uri.parse('http://blkpearl.org/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': auth.idToken, 'deviceId': deviceId}),
    );

    if (response.statusCode == 200) {
      AuthToken.jwt = jsonDecode(response.body)['token'];

      if (!context.mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Menu()),
      );
    } else {
      if (!context.mounted) return;

      final String message = jsonDecode(response.body)['message'];

      msgDiag(context, 'Falha no login: $message');
    }
  } on GoogleSignInException catch (e) {
    if (!context.mounted) return;

    msgDiag(context, 'Google Sign-In failed: ${e.code} / ${e.description}');
  } catch (e) {
    if (!context.mounted) return;

    msgDiag(context, 'Unexpected error: $e');
  }
}

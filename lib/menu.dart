import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:link_class_mobile/auth_token.dart';
import 'package:link_class_mobile/historico_page.dart';
import 'package:link_class_mobile/logos.dart';
import 'package:link_class_mobile/main.dart';
import 'package:link_class_mobile/qr_scanner.dart';
import 'package:link_class_mobile/util/error_msg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController _raController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _verificaEPedeRA();
  }

  Future<void> _verificaEPedeRA() async {
    final prefs = await SharedPreferences.getInstance();
    String? ra = prefs.getString('ra');

    if (ra == null || ra.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));

      ra = await _mostraDialogRA();

      if (ra == null || ra.isEmpty) {
        if (mounted) {
          await msgDiag(context, 'Por favor, digite o RA.');
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }

        return;
      }

      await prefs.setString('ra', ra);

      if (mounted) {
        await msgDiag(context, 'RA salvo com sucesso!');
      }
    }
  }

  Future<String?> _mostraDialogRA() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String? textoErro;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Informe seu RA'),
              content: TextField(
                controller: _raController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número do RA',
                  border: const OutlineInputBorder(),
                  errorText: textoErro,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final ra = _raController.text.trim();

                    final response = await http.post(
                      Uri.parse('http://192.168.41.105:3000/api/usuario/setRa'),
                      headers: {
                        'Content-Type': 'application/json',
                        'authorization': 'Bearer ${AuthToken.jwt}',
                      },
                      body: jsonEncode({'ra': ra}),
                    );

                    if (response.statusCode != 200) {
                      final res = jsonDecode(response.body);
                      final String message = res['message'];
                      final Map<dynamic, dynamic>? camposErro = res['campos'];

                      if (camposErro is Map<String, dynamic> && camposErro.isNotEmpty) {
                        final String erroRa = camposErro['ra'];

                        if (erroRa.isNotEmpty) {
                          setState(() {
                            textoErro = erroRa;
                          });

                          return;
                        }
                      } else {
                        if (context.mounted) {
                          await msgDiag(
                            context,
                            'Falha ao integrar RA com o servidor. Causa: $message',
                          );
                        }
                      }

                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      }

                      return;
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop(ra);
                    }
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffe20613),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      foregroundColor: Colors.white,
      minimumSize: const Size(50, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoUnipar(),
            const SizedBox(height: 20),
            const Text(
              'Seja Bem-Vindo!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () async {
                final scannedCode = await Navigator.of(context).push<String>(
                  MaterialPageRoute(builder: (_) => const QRScannerPage()),
                );

                if (scannedCode != null && context.mounted) {
                  await msgDiag(context, 'Código lido: $scannedCode');
                }
              },
              child: const Text('Ler QR Code'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HistoricoPage(),
                  ),
                );
              },
              child: const Text('Histórico'),
            ),
          ],
        ),
      ),
    );
  }
}

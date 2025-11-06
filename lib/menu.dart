import 'package:flutter/material.dart';
import 'package:link_class_mobile/logos.dart';
import 'package:link_class_mobile/qr_scanner.dart';
import 'package:link_class_mobile/historico_page.dart';
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
    final ra = prefs.getString('ra');

    if (ra == null || ra.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
      _showRADialog();
    }
  }

  Future<void> _showRADialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Informe seu RA'),
          content: TextField(
            controller: _raController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número do RA',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final ra = _raController.text.trim();

                if (ra.isEmpty) {
                  msgDiag(context, 'Por favor, digite o RA.');
                  return;
                }

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('ra', ra);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  msgDiag(context, 'RA salvo com sucesso!');
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
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
                  msgDiag(context, 'Código lido: $scannedCode');
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

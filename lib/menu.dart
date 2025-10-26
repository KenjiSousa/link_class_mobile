import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:link_class_mobile/qr_scanner.dart';
import 'package:link_class_mobile/historico_page.dart';
import 'package:link_class_mobile/util/error_msg.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffe20613),
      padding: EdgeInsets.symmetric(horizontal: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 25),
                ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvg(
                    rootBundle,
                    'assets/images/logo_unipar.svg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Texto de boas-vindas
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
                  MaterialPageRoute(builder: (_) => QRScannerPage()),
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
                Navigator.push(
                  context,
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

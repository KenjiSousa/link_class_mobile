import 'package:flutter/material.dart';
import 'package:link_class_mobile/qr_scanner.dart';
import 'package:link_class_mobile/util/error_msg.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}

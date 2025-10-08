import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  QRScannerPage({super.key});

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escaneando QR Code')),
      body: MobileScanner(
        controller: controller,
        onDetect: (result) {
          final valor = result.barcodes.first.rawValue;

          if (valor != null) {
            controller.stop();
            Navigator.of(context).pop(result.barcodes.first.rawValue);
          }
        },
      ),
    );
  }
}

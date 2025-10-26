import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    // Para a câmera quando a tela for fechada
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneando QR Code'),
        backgroundColor: const Color(0xffe20613),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (result) {
          final valor = result.barcodes.first.rawValue;

          if (valor != null) {
            controller.stop();
            Navigator.of(context).pop(valor);
          }
        },
      ),
    );
  }
}

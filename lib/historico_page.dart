import 'package:flutter/material.dart';
import 'package:link_class_mobile/logos.dart';

List<Map<String, String>>? eventos;

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    eventos = [
      {'data': '10/10/2025', 'hora': '19h10', 'titulo': 'Palestra sobre Empreendedorismo', 'duracao': '4h'},
      {'data': '10/10/2025', 'hora': '19h10', 'titulo': 'Palestra sobre Empreendedorismo', 'duracao': '4h'},
      {'data': '10/10/2025', 'hora': '19h10', 'titulo': 'Palestra sobre Empreendedorismo', 'duracao': '4h'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      appBar: barra(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            faixaLogo(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: eventos!.length,
                itemBuilder: criaItemHistorico,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar barra(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Histórico',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Container faixaLogo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: logoUnipar(0.25),
      ),
    );
  }

  Widget? criaItemHistorico(BuildContext context, int index) {
    final eventosHist = eventos;

    if (eventosHist == null) {
      return null;
    }

    final evento = eventosHist[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      evento['data']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      evento['hora']!,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  evento['titulo']!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe20613),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(60, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    child: Text(evento['duracao']!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

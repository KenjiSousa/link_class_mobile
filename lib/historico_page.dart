import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:link_class_mobile/auth_token.dart';
import 'package:link_class_mobile/logos.dart';
import 'package:link_class_mobile/util/error_msg.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<dynamic>? eventos;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarHistorico();
  }

  Future<void> carregarHistorico() async {
    try {
      final response = await http.get(
        Uri.parse('http://blkpearl.org/api/presenca'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${AuthToken.jwt}',
        },
      );
      final data = jsonDecode(response.body);
      
      setState(() {
        eventos = data;
        carregando = false;
      });
    } catch (e) {
      if (mounted) {
        await msgDiag(context, 'Erro ao carregar histórico: $e');
      }
      setState(() {
        carregando = false;
      });
    }
  }

  String formatarData(String dataIso) {
    final partes = dataIso.split('-'); // 2025-11-30 → [2025,11,30]
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  @override
  Widget build(BuildContext context) {
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
              child: carregando
                  ? const Center(child: CircularProgressIndicator())
                  : (eventos == null || eventos!.isEmpty)
                      ? const Center(child: Text('Nenhum evento encontrado.'))
                      : ListView.builder(
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

  Widget criaItemHistorico(BuildContext context, int index) {
    final eventoMap = eventos![index];
    final evento = eventoMap['evento'];
    final palestrante = evento['palestrantes']?.isNotEmpty == true
        ? evento['palestrantes'][0]['nome']
        : 'Desconhecido';

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
                      formatarData(evento['data']),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      '${evento['hr_ini']} - ${evento['hr_fim']}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  evento['nome'] ?? '',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Palestrante: $palestrante',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe20613),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                      minimumSize: const Size(60, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    child: Text('4h'),
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

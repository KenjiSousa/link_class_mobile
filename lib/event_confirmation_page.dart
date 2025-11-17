import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:link_class_mobile/auth_token.dart';
import 'package:link_class_mobile/util/error_msg.dart';

class EventConfirmacaoPage extends StatelessWidget {
  final Map<String, dynamic> evento;
  final String hashConfirmacao;

  const EventConfirmacaoPage({super.key, required this.evento, required this.hashConfirmacao});

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String dsNumero = evento['numero'] != null && evento['numero'].toString().isNotEmpty ? ', ${evento["numero"]}' : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de Evento'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.event_available,
              size: 80,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            Text(
              'Confirmação de Evento',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            _buildInfoRow('Evento:', evento['nome'] ?? 'Não informado'),
            _buildInfoRow('Data:', evento['data'] ?? 'Não informado'),
            _buildInfoRow('Horário:', evento['hr_ini'] ?? 'Não informado'),
            _buildInfoRow('Local:', '${evento["logradouro"]}$dsNumero'),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final response = await http.get(
                      Uri.parse('http://192.168.15.11:3000/api/presenca-link/verify/?hash=$hashConfirmacao'),
                      headers: {
                        'Content-Type': 'application/json',
                        'authorization': 'Bearer ${AuthToken.jwt}',
                      },
                    );

                    if (response.statusCode != 200) {
                      final res = jsonDecode(response.body);

                      if (context.mounted) {
                        await msgDiag(
                          context,
                          'Falha ao confirmar presença com o servidor. Causa: ${res["message"]}',
                        );
                      }
                    } else {
                      if (context.mounted) {
                        await msgDiag(
                          context,
                          'Presença registrada com sucesso!',
                        );
                      }

                      if (context.mounted) {
                        Navigator.of(context).pop(false);
                      }
                    }
                  },
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


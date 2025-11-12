import 'dart:convert'; 
import 'package:flutter/material.dart';

class EventConfirmacaoPage extends StatelessWidget {
  final String qrData; 

  const EventConfirmacaoPage({super.key, required this.qrData});

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
    Map<String, dynamic> eventData = {};
    String errorMessage = '';

    try {
      eventData = jsonDecode(qrData) as Map<String, dynamic>; 
    } catch (e) {
      errorMessage = 'QR Code inválido ou em formato inesperado.';
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro na Leitura')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$errorMessage\n\nDado lido: $qrData',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

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
            // Título
            Text(
              'Confirmação de Evento',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),
            
            _buildInfoRow('Evento:', eventData['nome'] ?? 'Não informado'),
            _buildInfoRow('Data:', eventData['data'] ?? 'Não informado'),
            _buildInfoRow('Horário:', eventData['horario'] ?? 'Não informado'),
            _buildInfoRow('Local:', eventData['local'] ?? 'Não informado'),
            
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
                  onPressed: () {
                    Navigator.of(context).pop(true); 
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


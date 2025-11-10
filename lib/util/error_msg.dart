import 'package:flutter/material.dart';

Future<void> msgDiag(BuildContext context, String message) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Aviso',
        textAlign: TextAlign.center,
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        )
      ],
    )
  );
}

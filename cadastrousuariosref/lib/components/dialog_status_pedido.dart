import 'package:flutter/material.dart';

Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Status do pedido'),
        content: const Text('Este pedido está:'),
        actions: [
          TextButton(
            child: const Text('Cancelado'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('Finalizado'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );

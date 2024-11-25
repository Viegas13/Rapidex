import 'package:flutter/material.dart';
import 'package:interfaces/View/ILoginGeral.dart';

void confirmarLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza de que deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o diálogo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginGeralScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      );
    },
  );
}

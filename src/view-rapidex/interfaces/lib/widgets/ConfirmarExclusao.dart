import 'package:flutter/material.dart';
import 'package:interfaces/View/IPerfilEntregador.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';

void confirmarExclusao(BuildContext context, Function excluirConta) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text(
            'Tem certeza de que deseja excluir sua conta? Essa ação não pode ser desfeita.'),
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
              excluirConta(); // Chama a função de exclusão passada
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      );
    },
  );
}

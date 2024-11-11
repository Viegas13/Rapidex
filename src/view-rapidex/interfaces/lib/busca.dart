import 'package:flutter/material.dart';

class BuscaScreen extends StatelessWidget {
  const BuscaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.orange,
          title: const TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text('Resultados de busca aparecerão aqui'),
          ),
        ),
      ],
    );
  }
}

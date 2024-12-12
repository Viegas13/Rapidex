import 'dart:io';

import 'package:flutter/material.dart';

class ImagemItem extends StatelessWidget {
  final Future<String?> imagemFuture;

  const ImagemItem({Key? key, required this.imagemFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: imagemFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Indicador de carregamento
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const Icon(Icons.error); // Ícone de erro
        } else {
          final String caminhoImagem = snapshot.data!;

          if (caminhoImagem.startsWith('http')) {
            return Image.network(
              caminhoImagem,
              fit: BoxFit.cover, // Preenche o espaço disponível
            );
          } else {
            return Image.file(
              File(caminhoImagem),
              fit: BoxFit.cover, // Preenche o espaço disponível
            );
          }
        }
      },
    );
  }
}

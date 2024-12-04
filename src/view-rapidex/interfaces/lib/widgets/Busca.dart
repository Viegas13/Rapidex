import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Busca extends StatelessWidget {
  final String nome;
  // final String imagem; // Retirar o comentário depois de corrigir a lógica da imagem
  final double preco;
  final String fornecedor;

  const Busca({
    super.key,
    required this.nome,
    // required this.imagem, // Retirar o comentário depois de corrigir a lógica da imagem
    required this.preco,
    required this.fornecedor,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Container(
      width: 120, // Largura fixa para itens
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinha os itens à esquerda
        children: [
          // Imagem do produto (Comentada, mas preparada para lógica futura)
          /* 
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imagem,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          */
          // Row para a imagem à esquerda e textos à direita
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinha os textos no topo
              children: [
                // Imagem (vai ocupar um espaço fixo)
                /* 
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imagem, 
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ), 
                */
                // Texto à direita da imagem
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fornecedor,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatter.format(preco),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
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

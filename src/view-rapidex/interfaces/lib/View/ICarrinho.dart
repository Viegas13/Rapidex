import 'package:flutter/material.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'IFinalizarpedido.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final List<Map<String, dynamic>> produtosCarrinho = [
    {'nome': 'Produto A', 'quantidade': 2, 'preco': 50.0},
    {'nome': 'Produto B', 'quantidade': 1, 'preco': 30.0},
    {'nome': 'Produto C', 'quantidade': 0, 'preco': 20.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Carrinho'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeClienteScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Produtos no Carrinho:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...produtosCarrinho.map((produto) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(produto['nome']),
                  Text("R\$ " + produto['preco'].toString()),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (produto['quantidade'] > 0) {
                              produto['quantidade']--;
                            }
                          });
                        },
                      ),
                      Text(produto['quantidade'].toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            produto['quantidade']++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Filtra os produtos com quantidade maior que 0 e envia para FinalizarPedido
                final produtosFiltrados = produtosCarrinho
                    .where((produto) => produto['quantidade'] > 0)
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalizarPedidoPage(
                      produtos: produtosFiltrados,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

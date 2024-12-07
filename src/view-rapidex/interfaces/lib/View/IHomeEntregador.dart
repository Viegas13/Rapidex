import 'package:flutter/material.dart';
import 'package:interfaces/View/IAcompanhamentoEntregador.dart';
import 'package:interfaces/View/IPerfilEntregador.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/Item.dart';
import '../DTO/Produto.dart';

class HomeEntregadorScreen extends StatefulWidget {
  const HomeEntregadorScreen({super.key});

  @override
  State<HomeEntregadorScreen> createState() => _HomeEntregadorScreenState();
}

class _HomeEntregadorScreenState extends State<HomeEntregadorScreen> {
  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior com perfil, "Meus pedidos" e carrinho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AcompanhamentoEntregadorScreen()),
                              //const PerfilEntregadorScreen(cpf: '13774195684')),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Minhas Entregas",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Opções de Entrega",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:interfaces/View/ICadastroCliente.dart';
import 'package:interfaces/View/ICadastroFornecedor.dart';
import 'package:interfaces/View/IHome.dart';
import 'package:interfaces/View/IPerfilCliente.dart';

//import 'package:interfaces/View/ICarrinho.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';
import 'package:interfaces/View/carrinho.dart';

import 'package:interfaces/View/IBusca.dart';
import 'package:interfaces/View/IPerfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapidex',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
      routes: {
        '/busca': (context) => const BuscaScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/carrinho': (context) => const CarrinhoPage(),
        '/perfil_cliente': (context) => const PerfilClienteScreen(cpf: "13774195684"),
        '/perfil_fornecedor': (context) => const PerfilFornecedorScreen(cnpj: "11111111111111"),
      },
    );
  }
}
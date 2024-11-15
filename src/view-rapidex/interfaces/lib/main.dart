import 'package:flutter/material.dart';
import 'package:interfaces/View/IHome.dart';
import 'package:interfaces/View/carrinho.dart';
import 'package:interfaces/View/IBusca.dart';
import 'package:interfaces/View/IPerfil.dart';
import 'package:interfaces/View/ICadastroCliente.dart';

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
      },
    );
  }
}

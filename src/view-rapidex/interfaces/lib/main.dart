import 'package:flutter/material.dart';
import 'package:interfaces/View/IAdicionarProduto.dart';
import 'package:interfaces/View/ICadastroCliente.dart';
import 'package:interfaces/View/ICadastroFornecedor.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';
import 'package:interfaces/View/Icarrinho.dart';

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
      home: const HomeClienteScreen(),
    );
  }
}

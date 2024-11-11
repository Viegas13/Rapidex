import 'package:flutter/material.dart';
import 'package:interfaces/home.dart';
import 'package:interfaces/busca.dart';
import 'package:interfaces/perfil.dart';

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
      },
    );
  }
}
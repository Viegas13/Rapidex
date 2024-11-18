import 'package:flutter/material.dart';
import 'package:interfaces/View/IAcessoCliente.dart';
import 'package:interfaces/View/IAcessoEntregador.dart';
import 'package:interfaces/View/IAcessoFornecedor.dart';
import 'package:interfaces/widgets/CustomTextField.dart';

class LoginGeralScreen extends StatefulWidget {
  const LoginGeralScreen({super.key});

  @override
  _LoginGeralScreenState createState() => _LoginGeralScreenState();
}

class _LoginGeralScreenState extends State<LoginGeralScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center( // Centra tudo horizontalmente
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza no eixo vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Garante centralização horizontal
          children: [
            // Logo e nome
            Column(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 100,
                  color: Colors.black,
                ),
                SizedBox(height: 8),
                Text(
                  'RAPIDEX',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            // Botões
            Column(
              children: [
                CustomButton(text: "Sou cliente"),
                SizedBox(height: 15),
                CustomButton(text: "Sou entregador"),
                SizedBox(height: 15),
                CustomButton(text: "Sou fornecedor"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;

  CustomButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: () {
          if (text == "Sou cliente") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AcessoClienteScreen()),
            );
          }
          else if (text == "Sou entregador") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AcessoEntregadorScreen()),
            );
          }
          else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AcessoFornecedorScreen()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Cor de fundo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
/* import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarEmail.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:postgres/postgres.dart';

class ICadastroFornecedor extends StatefulWidget {
  const ICadastroFornecedor({super.key});

  @override
  _ICadastroFornecedorState createState() => _ICadastroFornecedorState();
}

class _ICadastroFornecedorState extends State<ICadastroFornecedor> {
  late ConexaoDB conexaoDB;
  late FornecedorDAO fornecedorDAO;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PostgreSQLConnection connection = PostgreSQLConnection(
      'localhost',
      49798,
      'rapidex',
      username: '123456',
      password: '123456',
    );
    conexaoDB = ConexaoDB(connection: connection);
    fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

    conexaoDB.openConnection();
  }

  @override
  void dispose() {
    conexaoDB.closeConnection();
    nomeController.dispose();
    cnpjController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrarFornecedor() async {
    String email = emailController.text;

    if (!validar_email(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail inválido')),
      );
      return;
    }

    Map<String, dynamic> fornecedor = {
      'nome': nomeController.text,
      'cnpj': cnpjController.text,
      'telefone': telefoneController.text,
      'email': email,
      'senha': senhaController.text,
    };

    try {
      await fornecedorDAO.cadastrarFornecedor(fornecedor);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar fornecedor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cadastro de Fornecedor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: nomeController,
              labelText: 'Nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cnpjController,
              labelText: 'CNPJ',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: telefoneController,
              labelText: 'Telefone',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              labelText: 'E-mail',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: senhaController,
              labelText: 'Senha',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cadastrarFornecedor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 80), // Espaço extra na parte inferior
          ],
        ),
      ),
    );
  }
} */

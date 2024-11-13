import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:postgres/postgres.dart';

class LoginGeralScreen extends StatefulWidget {
  const LoginGeralScreen({super.key});

  @override
  _LoginGeralScreenState createState() => _LoginGeralScreenState();
}

class _LoginGeralScreenState extends State<LoginGeralScreen> {
  late ConexaoDB conexao;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Parâmetros da conexão do banco de dados
    PostgreSQLConnection connection = PostgreSQLConnection(
      '10.0.2.2',
      5432,
      'rapidex',
      username: 'postgres',
      password: '123456',
    );

    conexao = ConexaoDB(connection: connection);

    // Usa a classe de conexão pra ligar com o pgAdmin
    conexao.openConnection();
  }

  @override
  void dispose() {
    conexao.closeConnection();
    userNameController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  Future<void> logar() async {
    String userName = userNameController.text;
    String userPassword = userPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
              controller: userNameController,
              labelText: 'Nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: userPasswordController,
              labelText: 'CPF',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: logar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logar', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

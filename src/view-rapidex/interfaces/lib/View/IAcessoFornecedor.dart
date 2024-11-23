import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Fornecedor.dart';
import 'package:interfaces/View/ICadastroFornecedor.dart';
import 'package:interfaces/View/IHomeFornecedor.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:postgres/postgres.dart';

class AcessoFornecedorScreen extends StatefulWidget {
  const AcessoFornecedorScreen({super.key});

  @override
  _AcessoFornecedorScreenState createState() => _AcessoFornecedorScreenState();
}

class _AcessoFornecedorScreenState extends State<AcessoFornecedorScreen> {
  late ConexaoDB conexaoDB;
  late FornecedorDAO fornecedorDAO;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController =
      TextEditingController(); // olhar questão de criptografia

  @override
  void initState() {
    super.initState();

    conexaoDB = ConexaoDB();
    fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> logarFornecedor() async {
    String email = emailController.text;
    String senha = senhaController.text;

    Fornecedor? fornecedorLogado =
        await fornecedorDAO.BuscarFornecedorParaLogin(email, senha);

    if (fornecedorLogado != null) {
      print("opa");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeFornecedorScreen(cnpjFornecedor: "11111111111111")),
      );
    } else {
      print("FORNECEDOR NULL!!!!!!!!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 50),
            // Caixa de login
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "Bem vindo!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Campo de e-mail
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Campo de senha
                  TextField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      filled: true,
                      fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Links para "Esqueci minha senha" e "Cadastrar-se"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Ação para "Esqueci minha senha"
                        },
                        child: Text(
                          "Esqueci minha senha",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ICadastroFornecedor()),
                          );
                        },
                        child: Text(
                          "Cadastrar-se",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Botão Confirmar
            ElevatedButton(
              onPressed: logarFornecedor,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "Confirmar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

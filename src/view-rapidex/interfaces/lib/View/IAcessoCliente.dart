import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Cliente.dart';
import 'package:interfaces/View/ICadastroCliente.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/controller/emailController.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:postgres/postgres.dart';

class AcessoClienteScreen extends StatefulWidget {
  const AcessoClienteScreen({super.key});

  @override
  _AcessoClienteScreenState createState() => _AcessoClienteScreenState();
}

class _AcessoClienteScreenState extends State<AcessoClienteScreen> {
  late ConexaoDB conexaoDB;
  late ClienteDAO clienteDAO;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController =
      TextEditingController(); // olhar questão de criptografia

  Color corTextAreas = Colors.black12;
  bool clienteLogou = true;
  bool erroVisivel = false;

  @override
  void initState() {
    super.initState();

    conexaoDB = ConexaoDB();
    clienteDAO = ClienteDAO(conexaoDB: conexaoDB);

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

  Future<void> logarCliente() async {
    String email = emailController.text;
    String senha = senhaController.text;

    Cliente? clienteLogado =
        await clienteDAO.BuscarClienteParaLogin(email, senha);

    setState(() {
      if (clienteLogado != null) {
        corTextAreas = Colors.black12;
        clienteLogou = true;

        SessionController sessionController = SessionController();
        sessionController.setSession(email, senha);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeClienteScreen()),
        );
      } else {
        corTextAreas = Colors.red;
        clienteLogou = false;
        print("CLIENTE NULL!!!!!!!!!!!");
      }
    });
  }

  void toggleCaixaDeErroLogin() {
    setState(() {
      erroVisivel = !erroVisivel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back, // Ícone de seta
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
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
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: corTextAreas,
                                  )),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: senhaController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: corTextAreas,
                                  )),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Emailcontroller emailControllerEnvio =
                                      Emailcontroller();

                                  emailControllerEnvio.enviarEmail(
                                      "Recuperação de senha",
                                      "Sua nova senha eh tal",
                                      emailController.text);
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
                                        builder: (context) =>
                                            CadastroClienteScreen()),
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
                    ElevatedButton(
                      onPressed: () {
                        logarCliente();
                        toggleCaixaDeErroLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
            ),
            if (!clienteLogou)
              Positioned(
                left: 0,
                right: 0,
                top: 300,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: erroVisivel ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: Container(
                      width: 250,
                      height: 150,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 3, color: Colors.orange),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dados Incorretos",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              toggleCaixaDeErroLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                            ),
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}

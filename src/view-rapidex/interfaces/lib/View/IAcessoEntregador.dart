import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/View/ICadastroEntregador.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/View/IPerfilEntregador.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/EmailController.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:postgres/postgres.dart';

class AcessoEntregadorScreen extends StatefulWidget {
  const AcessoEntregadorScreen({super.key});

  @override
  _AcessoEntregadorScreenState createState() => _AcessoEntregadorScreenState();
}

class _AcessoEntregadorScreenState extends State<AcessoEntregadorScreen> {
  late ConexaoDB conexaoDB;
  late EntregadorDAO entregadorDAO;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController =
      TextEditingController(); // olhar questão de criptografia

  Color corTextAreas = Colors.black12;
  bool entregadorLogou = true;
  bool erroVisivel = false;

  @override
  void initState() {
    super.initState();

    conexaoDB = ConexaoDB();
    entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);

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

  Future<void> logarEntregador() async {
    String email = emailController.text;
    String senha = senhaController.text;

    Entregador? entregadorLogado =
        await entregadorDAO.buscarEntregadorParaLogin(email, senha);

    if (entregadorLogado != null) {
      setState(() {
        corTextAreas = Colors.black12;
        entregadorLogou = true;
      });

      SessionController sessionController = SessionController();
      sessionController.setSession(email, senha);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeEntregadorScreen()),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados Incorretos!')),
      );

      senhaController.clear();
    }
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
                                            CadastroEntregadorScreen()),
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
                        logarEntregador();
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
          ],
        ));
  }
}

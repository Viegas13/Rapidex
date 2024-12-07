import 'package:flutter/material.dart';
import 'package:interfaces/View/IHomeFornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarEmail.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCNPJ.dart';
import 'package:interfaces/controller/SessionController.dart';
//import 'IHomeFornecedor.dart';
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

  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    // Inicializa o objeto ConexaoDB
    conexaoDB = ConexaoDB();
    fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

    // Inicia a conexão com o banco de dados
    conexaoDB.initConnection().then((_) {
      // Após a conexão ser aberta, você pode adicionar lógica adicional, se necessário.
      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      // Se ocorrer um erro ao abrir a conexão, é bom tratar aqui.
      print('Erro ao estabelecer conexão no initState: $error');
    });
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
    if (!validar_CNPJ(cnpjController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CNPJ inválido')),
      );
      return;
    }

    try {
    Map<String, dynamic> fornecedor = {
      'cnpj': cnpjController.text,
      'nome': nomeController.text,
      'email': email,
      'senha': senhaController.text,
      'telefone': telefoneController.text,
    };

    sessionController.setSession(email, senhaController.text);

    print(sessionController.email);
      await fornecedorDAO.cadastrarFornecedor(fornecedor);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeFornecedorScreen()),
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
              hintText: 'Insira seu nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cnpjController,
              labelText: 'CNPJ',
              hintText: 'Insira seu cnpj',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: telefoneController,
              labelText: 'Telefone',
              hintText: 'Insira seu telefone',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: emailController,
              labelText: 'E-mail',
              hintText: 'Insira seu e-mail',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: senhaController,
              labelText: 'Senha',
              hintText: 'Insira sua senha',
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
} 
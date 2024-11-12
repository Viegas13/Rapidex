import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCPF.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarEmail.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/widgets/DatePicker.dart';
// import '../banco_de_dados/DAO/ClienteDAO.dart';

class CadastroClienteScreen extends StatefulWidget {
  const CadastroClienteScreen({super.key});

  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  late ConexaoDB conexaoDB;
  late ClienteDAO clienteDAO;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Parâmetros da conexão do banco de dados
    PostgreSQLConnection connection = PostgreSQLConnection(
      'localhost',
      49798,
      'rapidex',
      username: '123456',
      password: '123456',
    );
    conexaoDB = ConexaoDB(connection: connection);
    clienteDAO = ClienteDAO(conexaoDB: conexaoDB);

    // Usa a classe de conexão pra ligar com o pgAdmin
    conexaoDB.openConnection();
  }

  @override
  void dispose() {
    conexaoDB.closeConnection();
    nomeController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    dataNascimentoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> cadastrarCliente() async {
    String email = emailController.text;
    String cpf = cpfController.text;

    if (!validar_email(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail inválido')),
      );
      return;
    }

    if (!validar_cpf(cpf)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CPF inválido')),
      );
      return;
    }

    Map<String, dynamic> cliente = {
      'nome': nomeController.text,
      'cpf': cpf,
      'senha': senhaController.text,
      'email': email,
      'telefone': telefoneController.text,
      'datanascimento': dataNascimentoController.text,
    };

    try {
      await clienteDAO.cadastrarCliente(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar cliente')),
      );
    }
  }

  // Função para selecionar data
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dataNascimentoController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cadastro de Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
              controller: nomeController,
              labelText: 'Nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cpfController,
              labelText: 'CPF',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: telefoneController,
              labelText: 'Telefone',
            ),
            const SizedBox(height: 16),
            DatePickerField(
              controller: dataNascimentoController,
              onTap: () => _selectDate(context),
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
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: cadastrarCliente,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Cadastrar',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
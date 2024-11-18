import 'package:flutter/material.dart';
import 'package:interfaces/View/IHome.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCPF.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarEmail.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/widgets/DatePicker.dart';

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

    try {
      Map<String, dynamic> cliente = {
        'nome': nomeController.text,
        'cpf': cpf,
        'senha': senhaController.text,
        'email': email,
        'telefone': telefoneController.text,
        'datanascimento': dataNascimentoController.text,
      };

      await clienteDAO.cadastrarCliente(cliente);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      // Redirecionar para HomeScreen após sucesso
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (e.toString().contains('duplicate key') ||
          e.toString().contains('cpf')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Esse CPF já está cadastrado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar cliente')),
        );
      }
      print('Erro ao cadastrar cliente: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    setState(() {
      dataNascimentoController.text =
          DateFormat('dd/MM/yyyy').format(pickedDate!);
    });
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
              hintText: 'Insira seu nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cpfController,
              labelText: 'CPF',
              hintText: 'Insira seu CPF',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: telefoneController,
              labelText: 'Telefone',
              hintText: 'Insira seu telefone',
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
              hintText: 'Insira seu e-mail',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: senhaController,
              labelText: 'Senha',
              hintText: 'Insira sua senha',
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

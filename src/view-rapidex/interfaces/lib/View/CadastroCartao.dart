import 'package:flutter/material.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';
import '../banco_de_dados/DAO/CartaoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCPF.dart';
import 'package:interfaces/widgets/CustomTextField.dart';

class CadastroCartaoScreen extends StatefulWidget {
  const CadastroCartaoScreen({super.key});

  @override
  _CadastroCartaoScreenState createState() => _CadastroCartaoScreenState();
}

class _CadastroCartaoScreenState extends State<CadastroCartaoScreen> {
  late ConexaoDB conexaoDB;
  late CartaoDAO cartaoDAO;

  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController nomeTitularController = TextEditingController();
  final TextEditingController agenciaController = TextEditingController();
  final TextEditingController bandeiraController = TextEditingController();
  final TextEditingController clienteCpfController = TextEditingController();

 @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    cartaoDAO = CartaoDAO(conexaoDB: conexaoDB);
    conexaoDB.initConnection().then((_) {
       print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  @override
  void dispose() {
    numeroController.dispose();
    cvvController.dispose();
    validadeController.dispose();
    nomeTitularController.dispose();
    agenciaController.dispose();
    bandeiraController.dispose();
    clienteCpfController.dispose();
    super.dispose();
  }

  Future<void> cadastrarCartao() async {
    String cpf = clienteCpfController.text;
    if (!validar_cpf(cpf)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CPF inválido')),
      );
      return;
    }
    try {
      Map<String, dynamic> cartao = {
        'numero': int.parse(numeroController.text),
        'cvv': int.parse(cvvController.text),
        'validade': validadeController.text,
        'nomeTitular': nomeTitularController.text,
        'agencia': int.parse(agenciaController.text),
        'bandeira': bandeiraController.text,
        'cliente_cpf': clienteCpfController.text,
      };

      await cartaoDAO.cadastrarCartao(cartao);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cartão cadastrado com sucesso!')),
      );
      Navigator.pop(context); // Retorna para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar cartão')),
      );
      print('Erro ao cadastrar cartão: $e');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cadastro de Cartão'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
             const SizedBox(height: 16),
            CustomTextField(
              controller: numeroController,
               labelText: 'Numero do cartao',
              hintText: 'Insira o numero do cartão',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: cvvController,
              labelText: 'CVV',
              hintText: 'Insira o CVV do cartão',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: validadeController,
              labelText: 'Validade (MM/AAAA)',
              hintText: 'Insira a data de validade',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nomeTitularController,
              labelText: 'Nome do Titular',
              hintText: 'Insira seu nome',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: agenciaController,
              labelText: 'Agencia',
              hintText: 'Insira sua Agencia',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: bandeiraController,
              labelText: 'Bandeira',
              hintText: 'Insira a Bandeira',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: clienteCpfController,
              labelText: 'CPF',
              hintText: 'Insira seu CPF',
            ),
           const SizedBox(height: 16),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrarCartao,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Cadastrar Cartão'),
            ),
          ],
        ),
      ),
    );
  }
}

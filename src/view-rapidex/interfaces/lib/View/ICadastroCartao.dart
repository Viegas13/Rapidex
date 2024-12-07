import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Cartao.dart';
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
  final TextEditingController titularCpfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    cartaoDAO = CartaoDAO(conexaoDB: conexaoDB);
    
    // Aguarda a inicialização da conexão antes de continuar
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
    titularCpfController.dispose();
    super.dispose();
  }
  
Future<void> cadastrarCartao() async {
  String cpf = titularCpfController.text;

  // Validação do CPF
  if (!validar_cpf(cpf)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CPF inválido')),
    );
    return;
  }

  // Conversão e validação da validade do cartão
  String validadeTexto = validadeController.text; // Exemplo: "12/2030"
  DateTime? validade;

  try {
    List<String> partes = validadeTexto.split('/');
    if (partes.length == 2) {
      int mes = int.parse(partes[0]);
      int ano = int.parse(partes[1]);
      validade = DateTime(ano, mes);
    } else {
      throw FormatException("Formato de validade inválido");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data de validade inválida. Use MM/AAAA.')),
    );
    return; // Cancela o cadastro
  }

  try {
    // Garante que a conexão esteja aberta
    if (conexaoDB.connection.isClosed) {
      await conexaoDB.openConnection();
    }

    // Criação do objeto Cartão
    Cartao cartao = Cartao(
      numero: int.parse(numeroController.text),
      cvv: int.parse(cvvController.text),
      validade: validade, // Validade como DateTime
      nomeTitular: nomeTitularController.text,
      agencia: int.parse(agenciaController.text),
      bandeira: bandeiraController.text,
      cpf_titular: titularCpfController.text,
      clienteCpf: '02083037669',
   
    );

    // Cadastro do cartão no banco de dados
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
              controller: titularCpfController,
              labelText: 'CPF Titular',
              hintText: 'Insira CPF do titular',
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

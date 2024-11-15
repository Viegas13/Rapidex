import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCEP.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:postgres/postgres.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Importando o pacote

void main() {
  runApp(MaterialApp(
    home: CadastroEndereco(),
  ));
}

class CadastroEndereco extends StatefulWidget {
  const CadastroEndereco({super.key});

  @override
  State<CadastroEndereco> createState() => _CadastroEnderecoState();
}

class _CadastroEnderecoState extends State<CadastroEndereco> {
  late ConexaoDB conexaoDB;
  late EnderecoDAO enderecoDAO;
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _pontoReferenciaController =
      TextEditingController();

  // Definindo a máscara para o CEP (#####-###)
  final _cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {'#': RegExp(r'[0-9]')});

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
    enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);

    // Usa a classe de conexão pra ligar com o pgAdmin
    conexaoDB.openConnection();
  }

  @override
  void dispose() {
    conexaoDB.closeConnection();
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _pontoReferenciaController.dispose();
    super.dispose();
  }

  Future<void> cadastrarEndereco() async {
    final String cep = _cepController.text;
    final String numero = _numeroController.text;

    if (numero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número é obrigatório')),
      );
      return;
    }

    final Map<String, dynamic> endereco = {
      'cep': cep,
      'rua': _ruaController.text,
      'numero': numero,
      'bairro': _bairroController.text,
      'complemento': _complementoController.text,
      'referencia': _pontoReferenciaController.text,
    };

    try {
      await enderecoDAO.cadastrarEndereco(endereco);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço cadastrado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar endereço: ${e.toString()}')),
      );
    }
  }

  void _buscarEndereco() async {
    final cep = _cepController.text;
    if (cep.isEmpty || cep.length != 9) {
      // 9 é o tamanho com a formatação
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um CEP válido com 8 dígitos!')),
      );
      return;
    }

    final endereco = await CepService.buscarEnderecoPorCep(cep);
    if (endereco != null) {
      setState(() {
        _ruaController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CEP não encontrado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Cadastro de Endereço'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CustomTextField(
              controller: _cepController,
              labelText: 'CEP',
              inputFormatters: [_cepFormatter], // Aplicando a formatação
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _ruaController,
              labelText: 'Rua',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _bairroController,
              labelText: 'Bairro',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _numeroController,
              labelText: 'Número',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _complementoController,
              labelText: 'Complemento',
              obscureText: true,
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _pontoReferenciaController,
              labelText: 'Ponto de Referência',
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cadastrarEndereco,
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

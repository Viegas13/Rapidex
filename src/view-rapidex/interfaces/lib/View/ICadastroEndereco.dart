import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ValidarCEP.dart';
import 'package:interfaces/controller/SessionController.dart';

class CadastroEndereco extends StatefulWidget {
  const CadastroEndereco({super.key});

  @override
  State<CadastroEndereco> createState() => _CadastroEnderecoState();
}

class _CadastroEnderecoState extends State<CadastroEndereco> {
  late ConexaoDB conexaoDB;
  late EnderecoDAO enderecoDAO;
  late ClienteDAO clienteDAO;
  late FornecedorDAO fornecedorDAO;

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _pontoReferenciaController =
      TextEditingController();

  final _cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {'#': RegExp(r'[0-9]')});

  @override
void initState() {
  super.initState();
  conexaoDB = ConexaoDB();
  enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);
  clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
  fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

  conexaoDB.initConnection().then((_) {
    print('Conexão estabelecida no initState.');
  }).catchError((error) {
    print('Erro ao estabelecer conexão no initState: $error');
  });

  // Adiciona listener para buscar endereço ao preencher o CEP
  _cepController.addListener(() {
    final cep = _cepController.text.replaceAll('-', '');
    if (cep.length == 8) {
      _buscarEndereco();
    }
  });
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
  final String? email = SessionController.instancia.email;

  if (email == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro: Usuário não autenticado!')),
    );
    return;
  }

  // Recebe as informações do endereço
  final String cep = _cepController.text.replaceAll('-', '');
  final String numero = _numeroController.text;
  final String rua = _ruaController.text;
  final String bairro = _bairroController.text;
  final String complemento = _complementoController.text;
  final String referencia = _pontoReferenciaController.text;

  List<String> erros = [];
  if (cep.isEmpty || cep.length != 8) {
    erros.add('Digite um CEP válido com 8 dígitos.');
  }
  if (rua.isEmpty) {
    erros.add('Rua é obrigatória.');
  }
  if (bairro.isEmpty) {
    erros.add('Bairro é obrigatório.');
  }
  if (numero.isEmpty) {
    erros.add('Número é obrigatório.');
  }

  if (erros.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(erros.join('\n')),
        duration: const Duration(seconds: 3),
      ),
    );
    return;
  }

  try {
    // Identificação automática
    final String? cpf =
        await clienteDAO.buscarCpf(email, SessionController.instancia.senha);

    if (cpf != null) {
      // Cadastro de cliente
      await enderecoDAO.cadastrarEnderecoCliente({
        'cliente_cpf': cpf,
        'cep': cep,
        'rua': rua,
        'numero': numero,
        'bairro': bairro,
        'complemento': complemento,
        'referencia': referencia,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço cadastrado com sucesso para cliente!')),
      );

      // Redireciona para o perfil do cliente
      Navigator.pushReplacementNamed(context, '/perfil_cliente');
    } else {
      // Tenta buscar o CNPJ se não encontrou o CPF
      final String? cnpj = await fornecedorDAO.buscarCnpj(
          email, SessionController.instancia.senha);

      if (cnpj != null) {
        // Cadastro de fornecedor
        await enderecoDAO.cadastrarEnderecoFornecedor({
          'fornecedor_cnpj': cnpj,
          'cep': cep,
          'rua': rua,
          'numero': numero,
          'bairro': bairro,
          'complemento': complemento,
          'referencia': referencia,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Endereço cadastrado com sucesso para fornecedor!')),
        );

        // Redireciona para o perfil do fornecedor
        Navigator.pushReplacementNamed(context, '/perfil_fornecedor');
      } else {
        // Caso nem CPF nem CNPJ sejam encontrados
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: CPF ou CNPJ não encontrado!')),
        );
        return;
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar endereço: ${e.toString()}')),
    );
    print('Erro ao cadastrar endereço: $e');
  }
}

  Future<void> _buscarEndereco() async {
    final cep = _cepController.text.replaceAll('-', '');
    if (cep.isEmpty || cep.length != 8) return;

    final endereco = await CepService.buscarEnderecoPorCep(cep);
    if (endereco != null) {
      setState(() {
        _ruaController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _numeroController.text = '';
      });
    }
  }

  Future<void> _buscarCepPorEndereco() async {
    final rua = _ruaController.text;
    final bairro = _bairroController.text;
    final numero = _numeroController.text;

    if (rua.isEmpty || bairro.isEmpty || numero.isEmpty) return;

    final cep = await CepService.buscarCepPorEndereco(rua, bairro, numero);
    if (cep != null) {
      setState(() {
        _cepController.text = cep;
      });
    }
  }

  void _syncCepWithAddress() {
    if (_ruaController.text.isNotEmpty &&
        _bairroController.text.isNotEmpty &&
        _numeroController.text.isNotEmpty) {
      _buscarCepPorEndereco();
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
              hintText: 'Insira seu CEP',
              inputFormatters: [_cepFormatter],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _ruaController,
              labelText: 'Rua',
              hintText: 'Insira sua Rua',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _bairroController,
              labelText: 'Bairro',
              hintText: 'Insira seu Bairro',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _numeroController,
              labelText: 'Número',
              hintText: 'Insira o número',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _complementoController,
              labelText: 'Complemento',
              hintText: 'Insira seu complemento',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _pontoReferenciaController,
              labelText: 'Ponto de Referência',
              hintText: 'Opcional',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: cadastrarEndereco,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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

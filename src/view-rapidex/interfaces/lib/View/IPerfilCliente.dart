import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/CustomReadOnlyTextField.dart';
import 'package:interfaces/widgets/DropdownTextField.dart';

import 'package:intl/intl.dart'; // Importando o pacote para formatação de data

import 'package:intl/intl.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';


class PerfilClienteScreen extends StatefulWidget {
  final String cpf;

  const PerfilClienteScreen({Key? key, required this.cpf}) : super(key: key);

  @override
  _PerfilClienteScreenState createState() => _PerfilClienteScreenState();
}

class _PerfilClienteScreenState extends State<PerfilClienteScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cartaoController = TextEditingController();

  late ClienteDAO clienteDAO;
  late EnderecoDAO enderecoDAO;
  List<String> enderecosFormatados = ['Carregando...'];

  @override
  void initState() {
    super.initState();
    // Inicializando a conexão antes de usá-la
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);
      buscarCliente();

      buscarEnderecos();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');

    });
  }

  Future<void> buscarCliente() async {
    try {
      final cliente = await clienteDAO.buscarCliente(widget.cpf);
      if (cliente != null) {
        setState(() {
          nomeController.text = cliente.nome;
          // Convertendo a data de nascimento para string com formato desejado
          dataNascimentoController.text = cliente.dataNascimento != null
              ? DateFormat('dd/MM/yyyy').format(cliente.dataNascimento)
              : ''; 
          cpfController.text = cliente.cpf;
          telefoneController.text = cliente.telefone;
          emailController.text = cliente.email;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do cliente: $e');
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Conta'),
          content: const Text('Tem certeza de que deseja excluir sua conta? Esta ação é irreversível.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await clienteDAO.deletarCliente(cpfController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso!')),
      );
      Navigator.of(context).pop(); // Go back after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir conta')),
      );
      print('Erro ao excluir conta: $e');
    }
  }
  Future<void> buscarEnderecos() async {
    try {
      final enderecos = await enderecoDAO.listarEnderecos(widget.cpf);
      setState(() {
        enderecosFormatados = enderecos.map((endereco) {
          final complemento = endereco['complemento']?.isNotEmpty == true
              ? ', ${endereco['complemento']}'
              : '';
          final referencia = endereco['referencia']?.isNotEmpty == true
              ? ' (${endereco['referencia']})'
              : '';
          return '${endereco['rua']} ${endereco['numero']}, ${endereco['bairro']} $complemento $referencia'
              .trim();
        }).toList();
      });
    } catch (e) {
      print('Erro ao buscar endereços: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Dados pessoais'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CustomReadOnlyTextField(labelText: 'Nome', controller: nomeController),
                  CustomReadOnlyTextField(labelText: 'Data de nascimento', controller: dataNascimentoController),
                  CustomReadOnlyTextField(labelText: 'CPF', controller: cpfController),
                  CustomReadOnlyTextField(labelText: 'Telefone', controller: telefoneController),

                  DropdownTextField(labelText: 'Endereço', controller: enderecoController),
                  CustomReadOnlyTextField(labelText: 'E-mail', controller: emailController),
                  DropdownTextField(labelText: 'Cartões', controller: cartaoController),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CadastroEndereco(cpf: '13774195684')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar Novo Endereço',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownTextField(
                    labelText: 'Endereço',
                    controller: enderecoController,
                    items: enderecosFormatados.isNotEmpty &&
                            enderecosFormatados[0] != 'Carregando...'
                        ? enderecosFormatados
                        : ['Nenhum endereço disponível'],
                    onItemSelected: (selectedValue) {
                      setState(() {
                        enderecoController.text = selectedValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CadastroEndereco(cpf: '13774195684')) /*aqui deve viu o CadastroMetodoPagamento, só deixei esse pra preencher*/,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Adicionar Novo Método de Pagamento',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownTextField(labelText: 'Cartões', controller: cartaoController, items: ["Visa"],),
                  const SizedBox(height: 16),

                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement editing functionality here if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Editar informações', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _showDeleteConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Excluir conta', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class Cliente {
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String senha;
  final DateTime dataNascimento;

  Cliente({
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.dataNascimento,
  });

  // Método de fábrica para criar um Cliente a partir de um Map
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      nome: map['nome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      email: map['email'],
      senha: map['senha'],
      dataNascimento: DateTime.parse(map['datanascimento']),
    );
  }

  // Método para mapear o Cliente para um formato que o banco de dados entenda
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'datanascimento': dataNascimento.toIso8601String(),
    };
  }
}
import 'package:flutter/material.dart';
import 'package:interfaces/View/ICadastroEndereco.dart';
import 'package:interfaces/View/IEditarPerfilCliente.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/ConfirmarExclusao.dart';
import 'package:interfaces/widgets/CustomReadOnlyTextField.dart';
import 'package:interfaces/widgets/DropdownTextField.dart';
import 'package:interfaces/widgets/ConfirmarLogout.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';

class PerfilClienteScreen extends StatefulWidget {
  const PerfilClienteScreen({super.key});

  @override
  _PerfilClienteScreenState createState() => _PerfilClienteScreenState();
}

class _PerfilClienteScreenState extends State<PerfilClienteScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cartaoController = TextEditingController();

  late ClienteDAO clienteDAO;
  late EnderecoDAO enderecoDAO;
  late String cpf_cliente;
  List<String> enderecosFormatados = ['Carregando...'];
  String? enderecoSelecionado;

  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);
      inicializarDados();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> inicializarDados() async {
    try {
      cpf_cliente = await clienteDAO.buscarCpf(
              sessionController.email, sessionController.senha) ??
          '';
      if (cpf_cliente.isEmpty) {
        throw Exception('CPF não encontrado para o email e senha fornecidos.');
      }
      await buscarCliente();
      await buscarEnderecos();
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    }
  }

  Future<void> buscarCliente() async {
    try {
      final cliente = await clienteDAO.buscarCliente(cpf_cliente);
      if (cliente != null) {
        setState(() {
          nomeController.text = cliente.nome;
          dataNascimentoController.text = cliente.dataNascimento != null
              ? DateFormat('dd/MM/yyyy').format(cliente.dataNascimento!)
              : 'Não informado';

          cpfController.text = cliente.cpf.toString();
          telefoneController.text = cliente.telefone.toString();
          emailController.text = cliente.email;
        });
      }
    } catch (e) {
      print('Erro ao buscar cliente: $e');
    }
  }

  Future<void> buscarEnderecos() async {
    try {
      final enderecos = await enderecoDAO.listarEnderecosCliente(cpf_cliente);
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
        if (enderecosFormatados.isNotEmpty) {
          enderecoSelecionado ??= enderecosFormatados[0];
          enderecoController.text = enderecoSelecionado!;
        }
      });

      print('Endereços encontrados');
    } catch (e) {
      print('Erro ao buscar endereços: $e');
    }
  }

  Future<void> excluirContaCliente() async {
    try {
      await clienteDAO.deletarCliente(cpf_cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginGeralScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir conta')),
      );
      print('Erro ao excluir conta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Dados Pessoais'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeClienteScreen()),
            );
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
                  CustomReadOnlyTextField(
                      labelText: 'Nome', controller: nomeController),
                  CustomReadOnlyTextField(
                      labelText: 'Data de Nascimento',
                      controller: dataNascimentoController),
                  CustomReadOnlyTextField(
                      labelText: 'CPF', controller: cpfController),
                  CustomReadOnlyTextField(
                      labelText: 'Telefone', controller: telefoneController),
                  CustomReadOnlyTextField(
                      labelText: 'E-mail', controller: emailController),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastroEndereco(),
                        ),
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
                  /*const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CadastroEndereco(),
                        ),
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
                  DropdownTextField(
                    labelText: 'Cartões',
                    controller: cartaoController,
                    items: const ["Visa"],
                  ),*/
                  const SizedBox(height: 16),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditarPerfilClienteScreen(cpf: cpf_cliente),
                  ),
                );

                if (result == true) {
                  buscarCliente(); // Recarrega as informações após edição
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Editar Informações',
                  style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Alinha os botões de forma igualitária
              children: [
                ElevatedButton(
                  onPressed: () async {
                    confirmarLogout(context); // Passa o contexto como parâmetro
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sair da conta',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    confirmarExclusao(context, excluirContaCliente);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Excluir Conta',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

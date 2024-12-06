import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/DTO/Cliente.dart';

class EditarPerfilClienteScreen extends StatefulWidget {
  final String cpf;

  const EditarPerfilClienteScreen({super.key, required this.cpf});

  @override
  _EditarPerfilClienteScreenState createState() =>
      _EditarPerfilClienteScreenState();
}

class _EditarPerfilClienteScreenState extends State<EditarPerfilClienteScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late ClienteDAO clienteDAO;

  late String cpf_cliente;
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      inicializarDados();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> inicializarDados() async {
  try {
    cpf_cliente = await clienteDAO.buscarCpf(sessionController.email, sessionController.senha) ?? '';
    if (cpf_cliente.isEmpty) {
      throw Exception('CPF não encontrado para o email e senha fornecidos.');
    }
    await buscarCliente();
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

          // Converter o telefone de int para String
          telefoneController.text = cliente.telefone.toString();

          emailController.text = cliente.email;
        });
      }
    } catch (e) {
      print('Erro ao buscar cliente: $e');
    }
  }

  Future<void> salvarAlteracoes() async {
    try {
      final cliente = await clienteDAO.buscarCliente(cpf_cliente);

      if (cliente != null) {
        final clienteAtualizado = Cliente(
          cpf: cpf_cliente,
          nome: nomeController.text,
          senha: cliente.senha, // Manter a senha atual
          email: emailController.text,
          telefone: telefoneController.text,
          dataNascimento: dataNascimentoController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(dataNascimentoController.text)
              : null,
        );

        await clienteDAO.atualizarCliente(clienteAtualizado.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações atualizadas com sucesso!')),
        );

        // Passa um valor para a tela anterior para indicar que os dados foram atualizados
        Navigator.pop(context,
            true); // Passando `true` para indicar que as alterações foram feitas
      }
    } catch (e) {
      print('Erro ao salvar alterações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Atualizar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: nomeController,
                labelText: 'Nome',
                hintText: 'Digite seu nome',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: dataNascimentoController,
                labelText: 'Data de Nascimento',
                hintText: 'Digite sua data de nascimento',
                onTap: () async {
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
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: telefoneController,
                labelText: 'Telefone',
                hintText: 'Digite seu telefone',
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                hintText: 'Digite seu email',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Salvar Alterações',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

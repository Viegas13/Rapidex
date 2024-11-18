import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
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

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      buscarCliente();
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
      // Buscar o cliente para obter a senha atual antes de atualizar os outros dados
      final cliente = await clienteDAO.buscarCliente(widget.cpf);

      // Caso o cliente exista, atualiza os campos (excluindo a senha, que permanece inalterada)
      if (cliente != null) {
        final clienteAtualizado = Cliente(
          cpf: widget.cpf,
          nome: nomeController.text,
          senha: cliente.senha, // Manter a senha atual
          email: emailController.text,
          telefone: telefoneController.text,
          dataNascimento: dataNascimentoController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(dataNascimentoController.text)
              : null,
        );

        // Atualizar no banco de dados
        await clienteDAO.atualizarCliente(clienteAtualizado.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações atualizadas com sucesso!')),
        );
        Navigator.pop(context); // Voltar para a tela anterior
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

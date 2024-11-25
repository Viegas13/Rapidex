import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/DTO/Entregador.dart';

class EditarPerfilEntregadorScreen extends StatefulWidget {
  final String cpf;

  const EditarPerfilEntregadorScreen({super.key, required this.cpf});

  @override
  _EditarPerfilEntregadorScreenState createState() =>
      _EditarPerfilEntregadorScreenState();
}

class _EditarPerfilEntregadorScreenState extends State<EditarPerfilEntregadorScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late EntregadorDAO entregadorDAO;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      buscarEntregador();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> buscarEntregador() async {
    try {
      final entregador = await entregadorDAO.buscarEntregador(widget.cpf);
      if (entregador != null) {
        setState(() {
          nomeController.text = entregador.nome;
          dataNascimentoController.text = entregador.dataNascimento != null
              ? DateFormat('dd/MM/yyyy').format(entregador.dataNascimento!)
              : 'Não informado';

          // Converter o telefone de int para String
          telefoneController.text = entregador.telefone.toString();

          emailController.text = entregador.email;
        });
      }
    } catch (e) {
      print('Erro ao buscar Entregador: $e');
    }
  }

  Future<void> salvarAlteracoes() async {
    try {
      final entregador = await entregadorDAO.buscarEntregador(widget.cpf);

      if (entregador != null) {
        final entregadorAtualizado = Entregador(
          cpf: widget.cpf,
          nome: nomeController.text,
          senha: entregador.senha, // Manter a senha atual
          email: emailController.text,
          telefone: telefoneController.text,
          dataNascimento: dataNascimentoController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(dataNascimentoController.text)
              : null,
        );

        await entregadorDAO.atualizarEntregador(entregadorAtualizado.toMap());

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

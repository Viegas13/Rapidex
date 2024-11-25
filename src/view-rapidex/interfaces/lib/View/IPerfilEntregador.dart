import 'package:flutter/material.dart';
import 'package:interfaces/View/IEditarPerfilEntregador.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/ConfirmarExclusao.dart';
import 'package:interfaces/widgets/CustomReadOnlyTextField.dart';
import 'package:intl/intl.dart';

class PerfilEntregadorScreen extends StatefulWidget {
  final String cpf;

  const PerfilEntregadorScreen({super.key, required this.cpf});

  @override
  _PerfilEntregadorScreenState createState() => _PerfilEntregadorScreenState();
}

class _PerfilEntregadorScreenState extends State<PerfilEntregadorScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cartaoController = TextEditingController();

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

          cpfController.text = entregador.cpf.toString();
          telefoneController.text = entregador.telefone.toString();
          emailController.text = entregador.email;
        });
      }
    } catch (e) {
      print('Erro ao buscar Entregador: $e');
    }
  }

  Future<void> excluirConta() async {
    try {
      await entregadorDAO.deletarEntregador(widget.cpf);
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
                  builder: (context) => const HomeEntregadorScreen()),
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditarPerfilEntregadorScreen(cpf: widget.cpf),
                  ),
                );

                if (result == true) {
                  buscarEntregador(); // Recarrega as informações após edição
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
            ElevatedButton(
              onPressed: () async {
                confirmarExclusao(context);
                excluirConta();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Excluir Conta',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

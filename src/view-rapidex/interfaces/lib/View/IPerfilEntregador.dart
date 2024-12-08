import 'package:flutter/material.dart';
import 'package:interfaces/View/IEditarPerfilEntregador.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/ConfirmarExclusao.dart';
import 'package:interfaces/widgets/ConfirmarLogout.dart';
import 'package:interfaces/widgets/CustomReadOnlyTextField.dart';
import 'package:interfaces/controller/SessionController.dart';

import 'package:intl/intl.dart';

class PerfilEntregadorScreen extends StatefulWidget {

  const PerfilEntregadorScreen({super.key});

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
  late String cpf_entregador;
  SessionController sessionController = SessionController();
  late EntregadorDAO entregadorDAO;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      inicializarDados(); 
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }
  Future<void> inicializarDados() async {
  try {
    cpf_entregador = await entregadorDAO.buscarCpf(sessionController.email, sessionController.senha) ?? '';
    if (cpf_entregador.isEmpty) {
      throw Exception('CPF não encontrado para o email e senha fornecidos.');
    }
    await buscarEntregador();
  } catch (e) {
    print('Erro ao inicializar dados: $e');
  }
}

  Future<void> buscarEntregador() async {
    try {
      final entregador = await entregadorDAO.buscarEntregador(cpf_entregador);
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

  Future<void> excluirContaEntregador() async {
    try {
      await entregadorDAO.deletarEntregador(cpf_entregador);
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
                        EditarPerfilEntregadorScreen(cpf: cpf_entregador),
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
                    confirmarExclusao(context, excluirContaEntregador);
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

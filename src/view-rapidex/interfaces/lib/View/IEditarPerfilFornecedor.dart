import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/DTO/Fornecedor.dart';

class EditarPerfilFornecedorScreen extends StatefulWidget {
  final String cnpj;

  const EditarPerfilFornecedorScreen({super.key, required this.cnpj});

  @override
  _EditarPerfilFornecedorScreenState createState() =>
      _EditarPerfilFornecedorScreenState();
}

class _EditarPerfilFornecedorScreenState
    extends State<EditarPerfilFornecedorScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  late FornecedorDAO fornecedorDAO;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      buscarFornecedor();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> buscarFornecedor() async {
    try {
      final fornecedorMap = await fornecedorDAO.buscarFornecedor(widget.cnpj);
      if (fornecedorMap != null) {
        final fornecedor = Fornecedor.fromMap(
            fornecedorMap); // Converte o mapa em um objeto Fornecedor
        setState(() {
          nomeController.text = fornecedor.nome;
          telefoneController.text = fornecedor.telefone;
          emailController.text = fornecedor.email;
        });
      }
    } catch (e) {
      print('Erro ao buscar fornecedor: $e');
    }
  }

  Future<void> salvarAlteracoes() async {
  try {
    // Buscar o fornecedor para obter a senha atual antes de atualizar os outros dados
    final fornecedorMap = await fornecedorDAO.buscarFornecedor(widget.cnpj);

    // Certifique-se de que o mapa não é nulo e converta para um objeto Fornecedor
    if (fornecedorMap != null) {
      final fornecedor = Fornecedor.fromMap(fornecedorMap);

      // Atualizar os dados do fornecedor mantendo a senha atual, se não for alterada
      final fornecedorAtualizado = Fornecedor(
        cnpj: widget.cnpj,
        nome: nomeController.text,
        telefone: telefoneController.text,
        email: emailController.text,
        senha: senhaController.text.isNotEmpty ? senhaController.text : fornecedor.senha,
      );

      // Atualizar no banco de dados
      await fornecedorDAO.atualizarFornecedor(fornecedorAtualizado.toMap());

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
        backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
        title: const Text('Editar Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: senhaController,
                labelText: 'Senha',
                hintText: 'Digite sua senha',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: confirmarSenhaController,
                labelText: 'Confirmar nova senha',
                hintText: 'Digite novamente sua senha',
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Salvar Alterações',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

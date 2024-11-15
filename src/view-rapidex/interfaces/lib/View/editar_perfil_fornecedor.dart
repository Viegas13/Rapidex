import 'package:flutter/material.dart';

class EditarPerfilFornecedorScreen extends StatefulWidget {
  const EditarPerfilFornecedorScreen({super.key});

  @override
  _EditarPerfilFornecedorScreenState createState() =>
      _EditarPerfilFornecedorScreenState();
}

class _EditarPerfilFornecedorScreenState
    extends State<EditarPerfilFornecedorScreen> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  void _salvarDados() {
    if (_senhaController.text == _confirmarSenhaController.text) {
      // Ação do botão de salvar quando as senhas coincidem
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados salvos com sucesso!')),
      );
    } else {
      // Alerta se as senhas não coincidem
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('As senhas não coincidem. Por favor, tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volta para a tela anterior
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Ação do ícone de perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Editar Dados pessoais',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmarSenhaController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar nova senha',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _salvarDados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
    );
  }
}

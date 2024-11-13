import 'package:flutter/material.dart';
import 'editar_perfil_fornecedor.dart';

class perfil_fornecedorScreen extends StatelessWidget {
  const perfil_fornecedorScreen({super.key});

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
                  'Dados fornecedor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    hintText: 'nome',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'CNPJ',
                    hintText: '1179891234',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    hintText: '11978931234',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'teste@gmail.com',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 8),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: '********',
                    filled: true,
                    fillColor: Color.fromARGB(255, 202, 200, 200),
                  ),
                  enabled: false,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Ação do botão "Excluir conta"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Excluir conta'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EditarPerfilFornecedorScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Editar dados'),
                    ),
                  ],
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

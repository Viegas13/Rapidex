import 'package:flutter/material.dart';
import 'package:interfaces/View/IPerfilCliente.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.orange,
            title: const Text('Perfil'),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Dados Pessoais'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PerfilClienteScreen(cpf: '11122233344'), 
                      ),
                    );
                  },
                ),
                const ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                ),
                const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair da Conta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Perfil'),
        ),
        Expanded(
          child: ListView(
            children: const [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Dados Pessoais'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sair da Conta'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/widgets/ConfirmarExclusao.dart';
import 'IEditarPerfilFornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Fornecedor.dart';

class PerfilFornecedorScreen extends StatefulWidget {
  final String cnpj;

  const PerfilFornecedorScreen({super.key, required this.cnpj});

  @override
  _PerfilFornecedorScreenState createState() => _PerfilFornecedorScreenState();
}

class _PerfilFornecedorScreenState extends State<PerfilFornecedorScreen> {
  late FornecedorDAO fornecedorDAO;
  Fornecedor? fornecedor;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      carregarDadosFornecedor();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarDadosFornecedor() async {
    try {
      print("chegou na busca");
      final fornecedorMap =
          await fornecedorDAO.buscarFornecedor("11111111111111"); //widget.cnpj
      if (fornecedorMap != null) {
        setState(() {
          fornecedor = Fornecedor.fromMap(fornecedorMap);
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do fornecedor: $e');
    }
  }

  Future<void> excluirContaFornecedor() async {
    try {
      await fornecedorDAO.deletarFornecedor(widget.cnpj);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluída com sucesso!')),
      );
      //Navigator.of(context).popUntil((route) => route.isFirst); // Retorna à tela inicial

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginGeralScreen()),
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
        backgroundColor: const Color.fromRGBO(244, 140, 44, 1),
        title: const Text('Perfil do Fornecedor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: fornecedor == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReadOnlyField('Nome', fornecedor!.nome),
                    const SizedBox(height: 16),
                    _buildReadOnlyField('CNPJ', fornecedor!.cnpj),
                    const SizedBox(height: 16),
                    _buildReadOnlyField('Telefone', fornecedor!.telefone),
                    const SizedBox(height: 16),
                    _buildReadOnlyField('Email', fornecedor!.email),
                    const SizedBox(height: 24),
                    _buildReadOnlyField('Senha', fornecedor!.senha),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditarPerfilFornecedorScreen(
                                cnpj: fornecedor!.cnpj,
                              ),
                            ),
                          ).then((value) {
                            // Atualiza os dados após retornar da tela de edição
                            carregarDadosFornecedor();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(244, 140, 44, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          confirmarExclusao(context, excluirContaFornecedor);
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

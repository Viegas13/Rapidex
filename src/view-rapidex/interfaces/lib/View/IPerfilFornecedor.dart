import 'package:flutter/material.dart';
import 'package:interfaces/View/ILoginGeral.dart';
import 'package:interfaces/widgets/ConfirmarExclusao.dart';
import 'package:interfaces/widgets/ConfirmarLogout.dart';
import 'IEditarPerfilFornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Fornecedor.dart';
import 'package:interfaces/controller/SessionController.dart';

class PerfilFornecedorScreen extends StatefulWidget {

  const PerfilFornecedorScreen({super.key});

  @override
  _PerfilFornecedorScreenState createState() => _PerfilFornecedorScreenState();
}

class _PerfilFornecedorScreenState extends State<PerfilFornecedorScreen> {
  late FornecedorDAO fornecedorDAO;
  Fornecedor? fornecedor;
  String cnpj = '';
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      inicializarDados();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarDadosFornecedor() async {
    try {
      print("chegou na busca");
      final fornecedorMap =
          await fornecedorDAO.buscarFornecedor(cnpj); //widget.cnpj
      if (fornecedorMap != null) {
        setState(() {
          fornecedor = Fornecedor.fromMap(fornecedorMap);
        });
      }
    } catch (e) {
      print('Erro ao carregar dados do fornecedor: $e');
    }
  }

  Future<void> inicializarDados() async {
  try { 
    cnpj = await fornecedorDAO.buscarCnpj(sessionController.email, sessionController.senha) ?? '';
    if (cnpj.isEmpty) {
      throw Exception('CNPJ não encontrado para o email e senha fornecidos.');
    }
    carregarDadosFornecedor();
  } catch (e) {
    print('Erro ao inicializar dados: $e');
  }
}

  Future<void> excluirContaFornecedor() async {
    try {
      await fornecedorDAO.deletarFornecedor(cnpj);
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
                                  EditarPerfilFornecedorScreen(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Alinha os botões de forma igualitária
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            confirmarLogout(
                                context); // Passa o contexto como parâmetro
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
                      ],
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:interfaces/View/Ieditarperfilfornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';
import 'package:interfaces/View/IAdicionarProduto.dart';
import 'package:interfaces/View/IEditarProduto.dart';
import 'package:interfaces/DTO/Produto.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';

class HomeFornecedorScreen extends StatefulWidget {

  HomeFornecedorScreen({super.key});

  @override
  _HomeFornecedorScreenState createState() => _HomeFornecedorScreenState();
}

class _HomeFornecedorScreenState extends State<HomeFornecedorScreen> {
  late ConexaoDB conexaoDB;
  List<Produto> produtos = [];
  bool isLoading = true;
  late ProdutoDAO produtoDAO;
  late FornecedorDAO fornecedorDAO;
  late String cnpj;
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
      carregarProdutos();
      inicializarDados();
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<void> inicializarDados() async {
  try { 
    cnpj = await fornecedorDAO.buscarCnpj(sessionController.email, sessionController.senha) ?? '';
    if (cnpj.isEmpty) {
      throw Exception('CNPJ não encontrado para o email e senha fornecidos.');
    }
  } catch (e) {
    print('Erro ao inicializar dados: $e');
  }
}

  Future<void> carregarProdutos() async {
    try {
      print('Carregando produtos do fornecedor...');
      final resultado =
          await produtoDAO.listarProdutosFornecedor(cnpj);

      setState(() {
        produtos = resultado;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> excluirProduto(Produto produto) async {
    try {
      ProdutoDAO produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      await produtoDAO.removerProduto(produto.nome);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto excluído com sucesso!')),
      );
      await carregarProdutos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir produto')),
      );
      print('Erro ao excluir produto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 0, right: 20),
            color: Colors.orangeAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: 50.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilFornecedorScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Text(
            'Produtos cadastrados',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: (produto.imagem != null &&
                                  produto.imagem!.isNotEmpty)
                              ? Image.memory(
                                  produto.imagem!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons
                                        .image_not_supported); // Ícone se a imagem for inválida
                                  },
                                )
                              : Icon(Icons
                                  .image), // Ícone padrão se não houver imagem
                          title: Text(produto.nome),
                          subtitle: Text(
                              'Preço: R\$ ${produto.preco}\nQuantidade: ${produto.quantidade}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditarProdutoScreen(
                                          id: produto.produto_id,
                                          onProdutoEditado: carregarProdutos,),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  excluirProduto(produto);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarProdutoScreen(onProdutoAdicionado: carregarProdutos,)),
          );
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

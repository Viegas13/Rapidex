import "dart:io";
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
import 'package:interfaces/View/IPedidosFornecedor.dart';

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
  String cnpj = '';
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
    fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
      inicializarDados();
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<void> inicializarDados() async {
    try {
      cnpj = await fornecedorDAO.buscarCnpj(
              sessionController.email, sessionController.senha) ??
          '';
      if (cnpj.isEmpty) {
        throw Exception('CNPJ não encontrado para o email e senha fornecidos.');
      }
      await carregarProdutos();
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    }
  }

  Future<void> carregarProdutos() async {
    try {
      print('Carregando produtos do fornecedor...');
      print(cnpj);
      final resultado = await produtoDAO.listarProdutosFornecedor(cnpj);

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
      await produtoDAO.removerProduto(produto.produto_id);
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 0, right: 20),
            color: Colors.white,
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
                IconButton(
                  icon: const Icon(
                    Icons.list_alt,
                    color: Colors.grey,
                    size: 35.0,
                  ),
                  tooltip: 'Ver Pedidos',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PedidosFornecedorScreen(),
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
                              ? Image.file(
                                  File(produto
                                      .imagem), // Carrega imagem de arquivo local
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Erro ao carregar imagem: $error');
                                    return const Icon(
                                        Icons.image_not_supported);
                                  },
                                )
                              : const Icon(Icons
                                  .image), // Ícone padrão se não houver URL // Ícone padrão se não houver imagem
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
                                        onProdutoEditado: carregarProdutos,
                                      ),
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
            MaterialPageRoute(
                builder: (context) => AdicionarProdutoScreen(
                      onProdutoAdicionado: carregarProdutos,
                    )),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}

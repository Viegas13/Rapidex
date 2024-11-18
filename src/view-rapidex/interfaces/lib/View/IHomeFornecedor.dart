import 'package:flutter/material.dart';
import 'package:interfaces/View/Ieditarperfilfornecedor.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/View/IPerfilFornecedor.dart';
import 'package:interfaces/View/IAdicionarProduto.dart';

class HomeFornecedorScreen extends StatefulWidget {
  final String cnpjFornecedor;

  HomeFornecedorScreen({super.key, required this.cnpjFornecedor});

  @override
  _HomeFornecedorScreenState createState() => _HomeFornecedorScreenState();
}

class _HomeFornecedorScreenState extends State<HomeFornecedorScreen> {
  List<Map<String, dynamic>> produtos = [];
  bool isLoading = true;
  late ProdutoDAO produtoDAO;

  @override
  void initState() {
    super.initState();
    _fetchProdutos();
  }

  Future<void> _fetchProdutos() async {
    try {
      // Chame sua função para listar os produtos
      final produtosList =
          await produtoDAO.listarProdutos(widget.cnpjFornecedor);
      setState(() {
        produtos = produtosList;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: 40.0,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PerfilFornecedorScreen(
                  cnpj: '11111111111111',
                ),
              ),
            );
          },
        ),
        title: const Text(
          'Histórico de pedidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.account_circle, size: 30),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      children: [
                        _buildDynamicSection(
                          title: "Produtos cadastrados",
                          items: produtos
                              .map((produto) =>
                                  "${produto['nome']} (${produto['quantidade']})")
                              .toList(),
                          emptyMessage: "Nenhum produto cadastrado",
                        ),
                        const SizedBox(height: 20),
                        _buildDynamicSection(
                          title: "Pedidos em andamento",
                          items: [], // Aqui você pode adicionar a lógica dos pedidos
                          emptyMessage: "Nenhum pedido em andamento",
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdicionarProdutoScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                "Cadastrar Produto",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicSection({
    required String title,
    required List<String> items,
    required String emptyMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        if (items.isEmpty)
          Text(
            emptyMessage,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.map((item) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

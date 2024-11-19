import 'package:flutter/material.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/widgets/Produto.dart';
import '../DTO/Produto.dart';

class HomeClienteScreen extends StatefulWidget {
  const HomeClienteScreen({super.key});

  @override
  State<HomeClienteScreen> createState() => _HomeClienteScreenState();
}

class _HomeClienteScreenState extends State<HomeClienteScreen> {
  List<Produto> produtos = [];
  List<Produto> produtosFiltrados = [];
  bool isLoading = true;
  String termoBusca = "";

  late ProdutoDAO produtoDAO;

  @override
  void initState() {
    super.initState();
    produtoDAO = ProdutoDAO(conexaoDB: ConexaoDB());
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
  try {

    await produtoDAO.conexaoDB.openConnection();
    
    final resultado = await produtoDAO
        .listarProdutosComDetalhes('11111111111111'); // Fornecedor fictício
    setState(() {
      produtos = resultado;
      produtosFiltrados = resultado;
      isLoading = false;
    });
  } catch (e) {
    print('Erro ao carregar produtos: $e');
  }
}

  void _filtrarProdutos(String termo) {
    setState(() {
      termoBusca = termo;
      produtosFiltrados = produtos
          .where((produto) =>
              produto.nome.toLowerCase().contains(termo.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior com perfil, "Meus pedidos" e carrinho
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PerfilClienteScreen(cpf: '70275182606')),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Meus Pedidos",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.orange),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CarrinhoPage()),
                    );
                  },
                ),
              ],
            ),
            // Campo de busca
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar um dos nossos milhares de produtos',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: _filtrarProdutos,
              ),
            ),
            const SizedBox(height: 16),
            // Promoções e destaques
            SizedBox(
              height: 150,
              child: PageView(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Promoções + Destaques",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Novidades!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Listagem de produtos por categoria
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : produtosFiltrados.isEmpty
                      ? const Center(
                          child: Text("Nenhum produto encontrado."),
                        )
                      : ListView(
                          children: [
                            _buildCategoria("Hortifruit", produtosFiltrados),
                            _buildCategoria("Açougue", produtosFiltrados),
                            _buildCategoria("Embutidos", produtosFiltrados),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoria(String titulo, List<Produto> produtos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ProductItem(
                  nome: produto.nome,
                  imagem: produto.imagem,
                  preco: produto.preco,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

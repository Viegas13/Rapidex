import 'package:flutter/material.dart';
import 'package:interfaces/View/DetalhesProdutoBottomSheet.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/Item.dart';
import '../DTO/Produto.dart';

class HomeClienteScreen extends StatefulWidget {
  const HomeClienteScreen({super.key});

  @override
  State<HomeClienteScreen> createState() => _HomeClienteScreenState();
}

class _HomeClienteScreenState extends State<HomeClienteScreen> {
  List<Produto> produtos = [];
  Map<String, List<Produto>> produtosPorCategoria = {
    "Hortifruit": [],
    "Açougue": [],
    "Embutidos": [],
  };
  bool isLoading = true;
  String termoBusca = "";

  late ProdutoDAO produtoDAO;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      carregarProdutos();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarProdutos() async {

    try {
      final resultado = await produtoDAO
          .listarProdutosComDetalhes('11111111111111'); // Fornecedor fictício
      setState(() {
        produtos = resultado;
        _filtrarProdutos(); // Filtra os produtos após o carregamento
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool verificarCategoria(String descricao, String chave) {
    final regex = RegExp(chave, caseSensitive: false);
    return regex.hasMatch(descricao);
  }

  void _filtrarProdutos() {
    setState(() {
      produtosPorCategoria["Hortifruit"] = [];
      produtosPorCategoria["Açougue"] = [];
      produtosPorCategoria["Embutidos"] = [];
      produtosPorCategoria["Outros"] = [];

      for (var produto in produtos) {
        if (verificarCategoria(produto.descricao, "hortifruit|fruta|legume|verdura")) {
          produtosPorCategoria["Hortifruit"]?.add(produto);
        } else if (verificarCategoria(produto.descricao, "carne|açogue")) {
          produtosPorCategoria["Açougue"]?.add(produto);
        } else if (verificarCategoria(produto.descricao, "linguiça|embutido|salsicha")) {
          produtosPorCategoria["Embutidos"]?.add(produto);
        } else {
          produtosPorCategoria["Outros"]?.add(produto);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PerfilClienteScreen(cpf: '70275182606')),
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
                onChanged: (value) {
                  termoBusca = value;
                  _filtrarProdutos();
                },
              ),
            ),
            const SizedBox(height: 16),
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
                        "50% de desconto na primeira compra",
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
                        "Novidades em breve!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : produtosPorCategoria.isEmpty
                      ? const Center(
                          child: Text("Nenhum produto encontrado."),
                        )
                      : ListView(
                          children: [
                            _buildCategoria("Hortifruit"),
                            _buildCategoria("Açougue"),
                            _buildCategoria("Embutidos"),
                            _buildCategoria("Outros")
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoria(String titulo) {
    List<Produto> produtosCategoria = produtosPorCategoria[titulo] ?? [];

    return produtosCategoria.isEmpty && titulo != "Outros"
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  titulo,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: produtosCategoria.length,
                  itemBuilder: (context, index) {
                    final produto = produtosCategoria[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          // Filtrar produtos do mesmo fornecedor, removendo o selecionado
                          final produtosFornecedor = produtos
                              .where((p) =>
                                  p.fornecedorCnpj == produto.fornecedorCnpj &&
                                  p.nome != produto.nome)
                              .toList();

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return DetalhesProdutoBottomSheet(
                                produtoSelecionado: produto,
                                produtosCategoria: produtosCategoria,
                                produtosFornecedor: produtosFornecedor,
                              );
                            },
                          );
                        },
                        child: Item(
                          nome: produto.nome,
                          preco: produto.preco,
                        ),
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

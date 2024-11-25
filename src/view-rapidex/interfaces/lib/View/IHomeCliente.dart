import 'package:flutter/material.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
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
      print('Carregando produtos do fornecedor...');
      final resultado = await produtoDAO
          .listarProdutosComDetalhes('11111111111111'); // Fornecedor fictício

      print('Produtos carregados: ${resultado.length}');
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
    final regex = RegExp("r $chave", caseSensitive: false);
    return regex.hasMatch(descricao);
  }

  void _filtrarProdutos() {
    setState(() {
      // Limpa as categorias antes de preenchê-las
      produtosPorCategoria["Hortifruit"] = [];
      produtosPorCategoria["Açougue"] = [];
      produtosPorCategoria["Embutidos"] = [];
      produtosPorCategoria["Outros"] = []; // Categoria padrão

      // Filtra os produtos em cada categoria com base na descrição
      for (var produto in produtos) {
        if (verificarCategoria(
            produto.descricao, "hortifruit|fruta|legume|natural|verdura")) {
          produtosPorCategoria["Hortifruit"]?.add(produto);
        } else if (verificarCategoria(produto.descricao, "açogue|carne")) {
          produtosPorCategoria["Açougue"]?.add(produto);
        } else if (verificarCategoria(
            produto.descricao, "linguiça|embutido|salsicha")) {
          produtosPorCategoria["Embutidos"]?.add(produto);
        } else {
          print("chegou");
          produtosPorCategoria["Outros"]
              ?.add(produto); // Produtos sem categoria
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
                onChanged: (value) {
                  termoBusca = value;
                  _filtrarProdutos(); // Refiltra os produtos após busca
                },
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
            // Listagem de produtos por categoria
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
                      child: Item(
                        nome: produto.nome,
                        // imagem: produto.imagem, retirar o comentário depois de corrigir a lógica da imagem
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

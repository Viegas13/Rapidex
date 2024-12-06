import 'package:flutter/material.dart';
import 'package:interfaces/View/DetalhesProdutoBottomSheet.dart';
import 'package:interfaces/View/IPerfilCliente.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/Busca.dart';
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
  List<Produto> busca = [];
  bool isLoading = true;
  bool isSearching = false; // Variável para controlar o estado de busca
  String termoBusca = "";

  late ProdutoDAO produtoDAO;
  late FornecedorDAO fornecedorDAO;
  final TextEditingController buscaController = TextEditingController();

  SessionController sessionController = SessionController();
  

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      carregarProdutos();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }


 Future<void> buscarProdutos() async {
    try {
      final resultado = await produtoDAO.listarTodosProdutos(); 
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

  
  // Método que verifica a categoria
  bool verificarCategoria(String descricao, String chave) {
    final regex = RegExp(chave, caseSensitive: false);
    return regex.hasMatch(descricao);
  }

  // Método que filtra os produtos por categoria
  void _filtrarProdutos() {
    setState(() {
      produtosPorCategoria["Hortifruit"] = [];
      produtosPorCategoria["Açougue"] = [];
      produtosPorCategoria["Embutidos"] = [];
      produtosPorCategoria["Outros"] = []; // Categoria padrão

      for (var produto in produtos) {
        if (verificarCategoria(
            produto.descricao, "hortifruit|fruta|legume|verdura")) {
          produtosPorCategoria["Hortifruit"]?.add(produto);
        } else if (verificarCategoria(
            produto.descricao, "carne|açogue|bovino|frango")) {
          produtosPorCategoria["Açougue"]?.add(produto);
        } else if (verificarCategoria(
            produto.descricao, "linguiça|embutido|salsicha")) {
          produtosPorCategoria["Embutidos"]?.add(produto);
        } else {
          produtosPorCategoria["Outros"]
              ?.add(produto); // Produtos sem categoria
        }
      }
    });
  }

  // Carregar os produtos do banco de dados
  Future<void> carregarProdutos() async {
    try {
      print('Carregando produtos do fornecedor...');
      final resultado = await produtoDAO.listarTodosProdutos();

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

  // Carregar os resultados da busca
  Future<void> _carregarBusca(String chave) async {
    try {
      print('Carregando produtos buscados...');

      final resultado = await produtoDAO.buscarProdutosPorNome(chave);

      print('Produtos carregados: ${resultado.length}');
      setState(() {
        busca = resultado;
        isSearching = chave.isNotEmpty; // Ativa o estado de busca
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _cancelarBusca() {
    setState(() {
      isSearching = false;
      termoBusca = ""; // Limpa o termo de busca
      buscaController.clear(); // Limpa o conteúdo do TextField
      busca.clear(); // Limpa a lista de resultados
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
                              const PerfilClienteScreen()),
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
                controller:
                    buscaController, // Associar o controlador ao TextField
                decoration: InputDecoration(
                  hintText: 'Buscar um dos nossos milhares de produtos',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: _cancelarBusca, // Cancela a busca
                        )
                      : null,
                ),
                onChanged: (value) {
                  termoBusca = value;
                  _carregarBusca(value); // Atualiza os resultados da busca
                },
              ),
            ),
            const SizedBox(height: 16),
            // Exibe a seção de promoções e destaques apenas quando não estiver buscando
            if (!isSearching) ...[
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
            ],
            // Se estiver buscando, exibe os resultados da busca
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isSearching
                      ? _buildBusca() // Exibe a lista de busca
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

  // Exibe os produtos encontrados na busca
  Widget _buildBusca() {
  List<Produto> buscas = busca;

  return ListView.builder(
    itemCount: buscas.length,
    itemBuilder: (context, index) {
      final produto = buscas[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                  produtosCategoria: busca, // Passa a lista de busca como categoria
                  produtosFornecedor: produtosFornecedor,
                );
              },
            );
          },
          child: FutureBuilder<String?>(
            future: fornecedorDAO.buscarNomeFornecedor(produto.fornecedorCnpj),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Erro ao carregar fornecedor");
              } else if (snapshot.hasData) {
                final fornecedorNome =
                    snapshot.data ?? "Fornecedor desconhecido";

                return Busca(
                  nome: produto.nome,
                  fornecedor: fornecedorNome,
                  // imagem: produto.imagem, retirar o comentário depois de corrigir a lógica da imagem
                  preco: produto.preco,
                );
              } else {
                return const Text("Fornecedor não encontrado");
              }
            },
          ),
        ),
      );
    },
  );
}

  // Exibe os produtos de uma categoria
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
                          // imagem: produto.imagem, retirar o comentário depois de corrigir a lógica da imagem
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

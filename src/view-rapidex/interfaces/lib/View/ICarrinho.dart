import 'package:flutter/material.dart';
import 'package:interfaces/DTO/ItemPedido.dart';
import 'package:interfaces/DTO/Produto.dart';
import 'package:interfaces/View/IFinalizarpedido.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/ItemPedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/controller/SessionController.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';
import 'IAlterarStatusPedido.dart'; // Import da página - alterar pois não é a correta

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late ConexaoDB conexaoDB;
  late ItemPedidoDAO itemPedidoDAO;
  late ProdutoDAO produtoDAO;

  late List<ItemPedido> itensFinalizarPedido;

  List<ItemPedido> itensCarrinho = [];
  Map<int, String> nomesProdutos =
      {}; // Mapa para armazenar os nomes dos produtos
  bool carregando = true;
  late ClienteDAO clienteDAO;
  late String cpf_cliente; // CPF do cliente já refatorado com a sessão
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      itemPedidoDAO = ItemPedidoDAO(conexaoDB: conexaoDB);
      produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      inicializarDados();
      _carregarItensCarrinho();
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<void> inicializarDados() async {
    try {
      cpf_cliente = await clienteDAO.buscarCpf(
              sessionController.email, sessionController.senha) ??
          '';
      if (cpf_cliente.isEmpty) {
        throw Exception('CPF não encontrado para o email e senha fornecidos.');
      } else {
        print("CPF encontrado NO ICARRINHO! Esse é ele:");
        print(cpf_cliente);
      }
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    }
  }

  Future<void> _carregarItensCarrinho() async {
    try {
      final itens = await itemPedidoDAO.listarItensPedido();

      /* Filtrar itens com pedido_id == null(saber que aquele itemPedido não está em 
      nenhum pedido do cliente ainda) e cliente_cpf == cpf_cliente para confirmar
      que aquele itemPedido é de fato do cliente logado - já está refatorado usando a sessão
      */
      final itensFiltrados = itens
          .where((item) => item.pedidoId == 0 && item.clienteCpf == cpf_cliente)
          .toList();

      itensFinalizarPedido = itens.where((item) => item.pedidoId == 0 && item.clienteCpf == cpf_cliente).toList();

      // Obter os nomes dos produtos e armazenar no mapa
      for (var item in itensFiltrados) {
        final produto = await produtoDAO.buscarProduto(item.produtoId);
        if (produto != null) {
          nomesProdutos[item.produtoId] = produto.nome;
        } else {
          nomesProdutos[item.produtoId] = 'Produto Desconhecido';
        }
      }

      setState(() {
        itensCarrinho = itensFiltrados;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar itens do carrinho: $e');
      setState(() {
        carregando = false;
      });
    }
  }

  Future<void> _removerItem(ItemPedido item) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente excluir este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await itemPedidoDAO.removerItemPedido(item.itemPedidoId);
        setState(() {
          itensCarrinho.remove(item);
          nomesProdutos
              .remove(item.produtoId); // Remover o nome do produto do mapa
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido com sucesso.')),
        );
      } catch (e) {
        print('Erro ao remover item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao remover o item.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double subtotal = itensCarrinho.fold(
      0.0,
      (sum, item) => sum + (item.valorTotal),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Carrinho'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomeClienteScreen(), // Retorna para a home do cliente
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Produtos:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: itensCarrinho.length,
                itemBuilder: (context, index) {
                  final item = itensCarrinho[index];
                  final nomeProduto =
                      nomesProdutos[item.produtoId] ?? 'Produto Desconhecido';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Espaço reservado para a imagem do produto
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(Icons.image, size: 30),
                        ),
                        const SizedBox(width: 12),
                        // Dados do item
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nomeProduto,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Quantidade: ${item.quantidade}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'R\$ ${item.valorTotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        // Ícone da lixeira alinhado à direita
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 30),
                          onPressed: () => _removerItem(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'SUBTOTAL = R\$ ${subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    /*Deixei enviando para essa página, mas mudar para
                    FinalizarPedidoPage(), passando uma lista dos itens
                    do pedido
                    */
                    builder: (context) => FinalizarPedidoPage(produtos:itensFinalizarPedido),
                    //builder: (context) => IAlterarStatusPedido(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

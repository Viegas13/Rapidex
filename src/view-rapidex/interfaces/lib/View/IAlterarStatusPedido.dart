import 'package:flutter/material.dart';
import 'package:interfaces/DTO/ItemPedido.dart';
import 'package:interfaces/DTO/Produto.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/banco_de_dados/DAO/ItemPedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import '../banco_de_dados/DAO/PedidoDAO.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';
import '../DTO/Pedido.dart';

class IAlterarStatusPedido extends StatefulWidget {
  final int pedidoId;

  const IAlterarStatusPedido({Key? key, required this.pedidoId})
      : super(key: key);

  @override
  _IAlterarStatusPedidoState createState() => _IAlterarStatusPedidoState();
}

class _IAlterarStatusPedidoState extends State<IAlterarStatusPedido> {
  late ConexaoDB conexaoDB;
  late PedidoDAO pedidoDAO;
  late ProdutoDAO produtoDAO;
  late ItemPedidoDAO itemPedidoDAO;
  Pedido? pedido; // Objeto do pedido que será carregado
  bool isLoading = true; // Indica se os dados estão sendo carregados
  List<Map<String, dynamic>> itensPedido = [];
  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
    itemPedidoDAO = ItemPedidoDAO(conexaoDB: conexaoDB);
    produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      _carregarPedido();
      _carregarItensPedido();
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

 
  Future<void> _carregarPedido() async {
    try {
      Pedido? pedidoCarregado =
          await pedidoDAO.buscarPedidoPorId(widget.pedidoId);
      if (pedidoCarregado == null) {
        throw Exception('Pedido não encontrado.');
      }
      setState(() {
        pedido = pedidoCarregado;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar pedido: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
   Future<void> _carregarItensPedido() async {
    try {
      // Buscar itens do pedido
      List<ItemPedido> itens = await itemPedidoDAO.buscarItensPorPedido(widget.pedidoId);

      // Buscar informações dos produtos relacionados
      List<Map<String, dynamic>> itensDetalhados = [];
      for (var item in itens) {
        Produto? produto = await produtoDAO.buscarProduto(item.produtoId);
        if (produto != null) {
          itensDetalhados.add({
            'quantidade': item.quantidade,
            'nome': produto.nome,
            'valorTotal': item.valorTotal,
          });
        }
      }

      setState(() {
        itensPedido = itensDetalhados;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar itens do pedido: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> cancelarPedido() async {
    if (pedido == null) return;

    try {
      await pedidoDAO.atualizarStatusPedido(pedido!.pedido_id, 'cancelado');
      setState(() {
        pedido?.status_pedido = 'cancelado'; // Atualiza o status localmente
      });

      // Exibe um SnackBar para informar que o pedido foi cancelado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido cancelado com sucesso!')),
      );

      // Redireciona para a tela HomeClienteScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeClienteScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cancelar pedido')),
      );
      print('Erro: $e');
    }
  }

  void _confirmarCancelamento() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Cancelamento'),
          content:
              const Text('Tem certeza de que deseja cancelar este pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                cancelarPedido(); // Cancela o pedido
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Pedido'),
          backgroundColor: Colors.orange,
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white, // Fundo branco
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedido ID: ${pedido!.pedido_id}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${pedido!.status_pedido}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: itensPedido.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum item encontrado para este pedido.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ListView.builder(
                                itemCount: itensPedido.length,
                                itemBuilder: (context, index) {
                                  final item = itensPedido[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    color: Colors.orange.shade50,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16.0),
                                      title: Text(
                                        item['nome'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Quantidade: ${item['quantidade']}\nValor Total: R\$${item['valorTotal'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.bottomCenter, // Centraliza o botão
                        child: ElevatedButton(
                          onPressed: _confirmarCancelamento,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'CANCELAR PEDIDO',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
}


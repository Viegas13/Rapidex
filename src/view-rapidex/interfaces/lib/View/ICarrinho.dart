import 'package:flutter/material.dart';
import 'package:interfaces/View/IHomeCliente.dart';
import 'package:interfaces/View/IAlterarStatusPedido.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';
import '../banco_de_dados/DAO/PedidoDAO.dart';
import 'IFinalizarpedido.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  final List<Map<String, dynamic>> produtosCarrinho = [
    {'nome': 'Produto A', 'quantidade': 2, 'preco': 50.0},
    {'nome': 'Produto B', 'quantidade': 1, 'preco': 30.0},
    {'nome': 'Produto C', 'quantidade': 0, 'preco': 20.0},
  ];

  final String clienteCpf = '02083037669'; // CPF fixo do cliente
  late ConexaoDB conexaoDB;
  late PedidoDAO pedidoDAO;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
    conexaoDB.initConnection().then((_) {
      verificarPedidosPendentes();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

Future<void> verificarPedidosPendentes() async {
  try {
    // Garante que a conexão está aberta
    if (conexaoDB.connection.isClosed) {
      await conexaoDB.openConnection();
    }

    // Busca os pedidos com status pendente ou a caminho
    final pedidos = await PedidoDAO(conexaoDB: conexaoDB).buscarPedidosPorStatus(cliente_cpf: "02083037669", status_pedido: ['pendente', 'em preparo', 'pronto', 'retirado']);

      // Verifica se a lista de pedidos retornada está vazia ou não
      if (pedidos != null && pedidos.isNotEmpty) {
        final pedidoPendente = pedidos.first; // Pega o primeiro pedido encontrado
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IAlterarStatusPedido(),
          ),
        );
      } else {
        // Caso não haja pedidos pendentes, mantém a tela atual
        setState(() {
          carregando = false;
        });
      }
    } catch (e) {
      print('Erro ao verificar pedidos pendentes: $e');
      setState(() {
        carregando = false;
      });
      }
    }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  builder: (context) => const HomeClienteScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Produtos no Carrinho:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...produtosCarrinho.map((produto) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(produto['nome']),
                  Text("R\$ " + produto['preco'].toString()),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (produto['quantidade'] > 0) {
                              produto['quantidade']--;
                            }
                          });
                        },
                      ),
                      Text(produto['quantidade'].toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            produto['quantidade']++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final produtosFiltrados = produtosCarrinho
                    .where((produto) => produto['quantidade'] > 0)
                    .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalizarPedidoPage(
                      produtos: produtosFiltrados,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

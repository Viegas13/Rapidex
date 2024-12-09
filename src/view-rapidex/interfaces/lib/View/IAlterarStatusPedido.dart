import 'package:flutter/material.dart';
import 'package:interfaces/View/IHomeCliente.dart';
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
  Pedido? pedido; // Objeto do pedido que será carregado
  bool isLoading = true; // Indica se os dados estão sendo carregados

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      _carregarPedido();
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
        title: const Text('Alterar Status do Pedido'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedido == null
              ? const Center(child: Text('Pedido não encontrado.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido ID: ${pedido!.pedido_id}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status Atual: ${pedido!.status_pedido}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Cancelar Pedido:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _confirmarCancelamento,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('CANCELAR PEDIDO'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

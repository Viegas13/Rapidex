import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Pedido.dart';
import 'package:interfaces/View/IAlterarStatusPedido.dart';
import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/PedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';

class IListaPedidosScreen extends StatefulWidget {
  @override
  _IListaPedidosScreenState createState() => _IListaPedidosScreenState();
}

class _IListaPedidosScreenState extends State<IListaPedidosScreen> {
  late String cpfCliente; // CPF do cliente, carregado da sessão
  List<Map<String, dynamic>> pedidos = []; // Lista de pedidos
  bool isLoading = true; // Indica se os dados ainda estão carregando
  SessionController sessionController = SessionController();
  late PedidoDAO pedidoDAO;
  late ConexaoDB conexaoDB;
  late ClienteDAO clienteDAO;

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
    clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
    conexaoDB.initConnection().then((_) {
      carregarDados();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarDados() async {
    try {
      // Inicializa o CPF do cliente com base na sessão
      cpfCliente = await clienteDAO.buscarCpf(
            sessionController.email,
            sessionController.senha,
          ) ??
          '';
      if (cpfCliente.isEmpty) {
        throw Exception('CPF não encontrado para o email e senha fornecidos.');
      }

      // Busca os pedidos do cliente
      List<Pedido> listaPedidos = await pedidoDAO.buscarPedidosPorCliente(cpfCliente);

      // Filtra os pedidos para excluir os que estão com status "cancelado"
      List<Pedido> pedidosFiltrados = listaPedidos
          .where((pedido) => pedido.status_pedido.toLowerCase() != "cancelado")
          .toList();

      setState(() {
        pedidos = pedidosFiltrados
            .map((pedido) => {
                  'id': pedido.pedido_id,
                  'descricao': 'Pedido ${pedido.pedido_id} - R\$${pedido.preco.toStringAsFixed(2)} - Stauts: ${pedido.status_pedido}'
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Pedidos")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
              ? const Center(child: Text("Nenhum pedido encontrado."))
              : ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IAlterarStatusPedido(pedidoId: pedido['id']),
                          ),
                        );
                      },
                      child: Text(pedido['descricao']),
                    );
                  },
                ),
    );
  }
}

// Página de destino ao clicar em um pedido
class PaginaX extends StatelessWidget {
  final int pedidoId;

  const PaginaX({Key? key, required this.pedidoId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalhes do Pedido")),
      body: Center(
        child: Text("Exibindo detalhes do pedido ID: $pedidoId"),
      ),
    );
  }
}

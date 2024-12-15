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
  late String cpfCliente;
  List<Map<String, dynamic>> pedidos = [];
  bool isLoading = true;
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
      cpfCliente = await clienteDAO.buscarCpf(
            sessionController.email,
            sessionController.senha,
          ) ??
          '';
      if (cpfCliente.isEmpty) {
        throw Exception('CPF não encontrado para o email e senha fornecidos.');
      }

      List<Pedido> listaPedidos =
          await pedidoDAO.buscarPedidosPorCliente(cpfCliente);

      List<Pedido> pedidosFiltrados = listaPedidos
          .where((pedido) => !["cancelado", "concluido"]
              .contains(pedido.status_pedido.toLowerCase()))
          .toList();

      setState(() {
        pedidos = pedidosFiltrados
            .map((pedido) => {
                  'id': pedido.pedido_id,
                  'descricao':
                      'Pedido ${pedido.pedido_id} - R\$${pedido.preco.toStringAsFixed(2)} - Status: ${pedido.status_pedido}'
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
      appBar: AppBar(
        title: const Text(
          "Lista de Pedidos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum pedido encontrado.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];
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
                            pedido['descricao'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    IAlterarStatusPedido(pedidoId: pedido['id']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

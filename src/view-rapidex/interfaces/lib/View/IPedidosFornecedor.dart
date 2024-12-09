import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DAO/PedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Pedido.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:intl/intl.dart';

class PedidosFornecedorScreen extends StatefulWidget {
  const PedidosFornecedorScreen({super.key});

  @override
  _PedidosFornecedorScreenState createState() =>
      _PedidosFornecedorScreenState();
}

class _PedidosFornecedorScreenState extends State<PedidosFornecedorScreen> {
  late PedidoDAO pedidoDAO;
  late ConexaoDB conexaoDB;
  late FornecedorDAO fornecedorDAO;
  List<Pedido> pedidosAndamento = [];
  List<Pedido> pedidosHistorico = [];
  bool isLoading = true;
  SessionController sessionController = SessionController();

  final List<String> statusList = [
    'pendente',
    'em preparo',
    'pronto',
    'retirado',
    'cancelado',
  ];

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    conexaoDB.initConnection().then((_) {
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
      carregarPedidos();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarPedidos() async {
    String cnpj = await fornecedorDAO.buscarCnpj(
            sessionController.email, sessionController.senha) ??
        '';

    if (cnpj.isEmpty) {
      print('Fornecedor não encontrado ou CNPJ vazio!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final pedidos = await pedidoDAO.buscarPedidosPorFornecedor(cnpj);
      final DateTime today = DateTime.now();
      final String todayStr = DateFormat('yyyy-MM-dd').format(today);

      setState(() {
        pedidosAndamento = pedidos
            .where((pedido) =>
                pedido.status_pedido != 'retirado' &&
                pedido.status_pedido != 'cancelado' &&
                DateFormat('yyyy-MM-dd').format(pedido.data_de_entrega) ==
                    todayStr)
            .toList();

        pedidosHistorico = pedidos
            .where((pedido) =>
                (pedido.status_pedido == 'retirado' ||
                    pedido.status_pedido == 'cancelado') &&
                DateFormat('yyyy-MM-dd').format(pedido.data_de_entrega) ==
                    todayStr)
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar pedidos: $e');
    }
  }

  Future<List<Map<String, dynamic>>> buscarItensDoPedido(int? pedidoId) async {
    try {
      return await pedidoDAO.buscarItensPorPedido(pedidoId);
    } catch (e) {
      print('Erro ao buscar itens do pedido: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos do Fornecedor'),
          backgroundColor: Colors.orange,
          bottom: const TabBar(
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: 'Em Andamento'),
              Tab(text: 'Histórico'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.orange))
            : TabBarView(
                children: [
                  _buildPedidosListView(pedidosAndamento),
                  _buildPedidosListView(pedidosHistorico),
                ],
              ),
      ),
    );
  }

  Widget _buildPedidosListView(List<Pedido> pedidos) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: buscarItensDoPedido(pedido.pedido_id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.orange));
            } else if (snapshot.hasError) {
              return ListTile(
                title: Text('Pedido #${pedido.pedido_id}'),
                subtitle: const Text('Erro ao carregar itens do pedido'),
              );
            } else {
              final itens = snapshot.data ?? [];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text('Pedido #${pedido.pedido_id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status atual: ${pedido.status_pedido}'),
                      // Exibindo os itens do pedido
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: itens.map((item) {
                          return Text(
                            'Produto: ${item['nome_produto']}, Quantidade: ${item['quantidade']}, Total: ${item['valor_total']}',
                            style: const TextStyle(fontSize: 14),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: statusList.contains(pedido.status_pedido)
                            ? pedido.status_pedido
                            : statusList.first,
                        onChanged: (String? novoStatus) {
                          if (novoStatus != null) {
                            alterarStatus(pedido, novoStatus);
                          }
                        },
                        items: statusList.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        dropdownColor: Colors
                            .orange[50], // Fundo do dropdown laranja claro
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> alterarStatus(Pedido pedido, String novoStatus) async {
    try {
      await pedidoDAO.atualizarStatusPedido(pedido.pedido_id, novoStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Status do pedido atualizado com sucesso!',
                style: TextStyle(color: Colors.orange))),
      );
      carregarPedidos(); // Recarrega a lista de pedidos após a alteração
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao atualizar status',
                style: TextStyle(color: Colors.red))),
      );
      print('Erro ao atualizar status: $e');
    }
  }
}

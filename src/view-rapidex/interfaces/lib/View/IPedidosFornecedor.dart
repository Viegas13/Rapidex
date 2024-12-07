import 'package:flutter/material.dart';
import 'package:interfaces/banco_de_dados/DAO/PedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Pedido.dart';
import 'package:interfaces/controller/SessionController.dart';

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

    String cnpj = await fornecedorDAO.buscarCnpj(sessionController.email, sessionController.senha) ?? '';

    if (cnpj.isEmpty) {
      print('Fornecedor não encontrado ou CNPJ vazio!');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final pedidos = await pedidoDAO.buscarPedidosPorFornecedor(cnpj);
      setState(() {
        pedidosAndamento = pedidos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar pedidos: $e');
    }
  }

  Future<void> alterarStatus(Pedido pedido, String novoStatus) async {
    try {
      await pedidoDAO.atualizarStatusPedido(pedido.pedido_id, novoStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status do pedido atualizado com sucesso!')),
      );
      carregarPedidos(); // Recarrega a lista de pedidos após a alteração
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar status')),
      );
      print('Erro ao atualizar status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos do Fornecedor'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pedidosAndamento.length,
              itemBuilder: (context, index) {
                final pedido = pedidosAndamento[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text('Pedido #${pedido.pedido_id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status atual: ${pedido.status_pedido}'),
                        DropdownButton<String>(
                          value: pedido.status_pedido,
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

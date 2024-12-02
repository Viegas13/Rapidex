import 'package:flutter/material.dart';
import '../banco_de_dados/DAO/PedidoDAO.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';

class IAlterarStatusPedido extends StatefulWidget {
  @override
  _IAlterarStatusPedidoState createState() => _IAlterarStatusPedidoState();
}

class _IAlterarStatusPedidoState extends State<IAlterarStatusPedido> {
  late ConexaoDB conexaoDB;
  late PedidoDAO pedidoDAO;

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<void> alterarStatusPedido(int pedidoId, String novoStatus) async {
    try {
      await pedidoDAO.atualizarStatusPedido(pedidoId, novoStatus);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status atualizado para $novoStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status')),
      );
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Status do Pedido'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => alterarStatusPedido(1, 'pendente'),
              child: const Text('Pendente'),
            ),
            ElevatedButton(
              onPressed: () => alterarStatusPedido(1, 'a caminho'),
              child: const Text('A Caminho'),
            ),
            ElevatedButton(
              onPressed: () => alterarStatusPedido(1, 'cancelado'),
              child: const Text('Cancelado'),
            ),
            ElevatedButton(
              onPressed: () => alterarStatusPedido(1, 'entregue'),
              child: const Text('Entregue'),
            ),
          ],
        ),
      ),
    );
  }
}

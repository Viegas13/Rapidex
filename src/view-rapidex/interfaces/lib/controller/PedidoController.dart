import 'package:interfaces/DTO/ProdutosCompra.dart';

class PedidoController {
  void processarPedido(List<Map<String, dynamic>> produtosMap) {
    try {
      // Converte os mapas para objetos ProdutosCompra
      final produtos = produtosMap.map((map) => ProdutosCompra.fromMap(map)).toList();

      // Processa o pedido normalmente
      for (var produto in produtos) {
        print('Produto: ${produto.nome}, Quantidade: ${produto.quantidade}');
      }

      print('Pedido processado com sucesso!');
    } catch (e) {
      print('Erro ao processar o pedido: $e');
      throw e;
    }
  }
}

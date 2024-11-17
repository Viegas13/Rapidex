import '../DTO/ProdutosCompra.dart';

class PedidoController {
  void processarPedido(List<ProdutosCompra> produtos) {
    for (var produto in produtos) {
      print('Produto: ${produto.nome}, Quantidade: ${produto.quantidade}, Preço: ${produto.preco}');
    }
    // Aqui pode adicionar lógica para salvar no banco ou enviar para uma API
    print('Pedido processado com sucesso!');
  }
}

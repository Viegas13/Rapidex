class ItemPedido {
  final int itemPedidoId;
  final int produtoId;
  final int pedidoId;
  final int quantidade;
  final double valorTotal;
  final String clienteCpf;

  ItemPedido({
    required this.itemPedidoId,
    required this.produtoId,
    required this.pedidoId,
    required this.quantidade,
    required this.valorTotal,
    required this.clienteCpf,
  });

  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      itemPedidoId: map['item_pedido_id'] ?? 0,
      produtoId: map['produto_id'] ?? 0,
      pedidoId: map['pedido_id'] ?? 0,
      quantidade: map['quantidade'] ?? 0,
      valorTotal: map['valor_total']?.toDouble() ?? 0.0,
      clienteCpf: map['cliente_cpf'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_pedido_id': itemPedidoId,
      'produto_id': produtoId,
      'pedido_id': pedidoId,
      'quantidade': quantidade,
      'valor_total': valorTotal,
      'cliente_cpf': clienteCpf,
    };
  }
}

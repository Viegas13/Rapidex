class Pedido {
  final int? pedidoId;
  final String clienteCpf;
  final String fornecedorCnpj;
  final String entregadorCpf;
  final double preco;
  final String statusPedido;

  Pedido({
    this.pedidoId,
    required this.clienteCpf,
    required this.fornecedorCnpj,
    required this.entregadorCpf,
    required this.preco,
    this.statusPedido = 'pendente',
  });

  // Construtor para conversão de Map para Pedido
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      pedidoId: map['pedido_id'] as int?,
      clienteCpf: map['cliente_cpf'] as String,
      fornecedorCnpj: map['fornecedor_cnpj'] as String,
      entregadorCpf: map['entregador_cpf'] as String,
      preco: map['preco'] as double,
      statusPedido: map['status_pedido'] as String,
    );
  }

  // Converte o Pedido para Map (para envio ao banco)
  Map<String, dynamic> toMap() {
    return {
      'pedido_id': pedidoId,
      'cliente_cpf': clienteCpf,
      'fornecedor_cnpj': fornecedorCnpj,
      'entregador_cpf': entregadorCpf,
      'preco': preco,
      'status_pedido': statusPedido,
    };
  }
}

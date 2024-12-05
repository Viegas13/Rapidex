class Pedido {
  final int? pedidoId;
  final String cliente_cpf;
  final String fornecedor_cnpj;
  final String entregador_cpf;
  final double preco;
  final String status_pedido;

  Pedido({
    this.pedidoId,
    required this.cliente_cpf,
    required this.fornecedor_cnpj,
    required this.entregador_cpf,
    required this.preco,
    this.status_pedido = 'pendente',
  });

  // Construtor para conversão de Map para Pedido
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      pedidoId: map['pedido_id'] as int?,
      cliente_cpf: map['cliente_cpf'] as String,
      fornecedor_cnpj: map['fornecedor_cnpj'] as String,
      entregador_cpf: map['entregador_cpf'] as String,
      preco: map['preco'] as double,
      status_pedido: map['status_pedido'] as String,
    );
  }

  // Converte o Pedido para Map (para envio ao banco)
  Map<String, dynamic> toMap() {
    return {
      'pedido_id': pedidoId,
      'cliente_cpf': cliente_cpf,
      'fornecedor_cnpj': fornecedor_cnpj,
      'entregador_cpf': entregador_cpf,
      'preco': preco,
      'status_pedido': status_pedido,
    };
  }
}

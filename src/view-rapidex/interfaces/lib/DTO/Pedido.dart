class Pedido {
  int? pedido_id;
  String cliente_cpf;
  String fornecedor_cnpj;
  double preco;
  double frete;
  String endereco_entrega; // Novo campo
  String status_pedido;

  Pedido({
    this.pedido_id,
    required this.cliente_cpf,
    required this.fornecedor_cnpj,
    required this.preco,
    required this.frete,
    required this.endereco_entrega,
    this.status_pedido = 'pendente',
  });

  // Conversão para map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'pedido_id': pedido_id,
      'cliente_cpf': cliente_cpf,
      'fornecedor_cnpj': fornecedor_cnpj,
      'preco': preco,
      'frete': frete,
      'endereco_entrega': endereco_entrega,
      'status_pedido': status_pedido,
    };
  }

  // Conversão de map (ao buscar no banco)
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      pedido_id: map['pedido_id'],
      cliente_cpf: map['cliente_cpf'],
      fornecedor_cnpj: map['fornecedor_cnpj'],
      preco: (map['preco'] as double?) ?? 0.0, // Tratar null como 0.0
      frete: (map['frete'] as double?) ?? 0.0, // Tratar null como 0.0
      endereco_entrega: map['endereco_entrega'],
      status_pedido: map['status_pedido'] ?? 'pendente',
    );
  }
}

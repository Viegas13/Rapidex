class ProdutosCompra {
  final String nome;
  final int quantidade;
  final double preco;

  ProdutosCompra({
    required this.nome,
    required this.quantidade,
    required this.preco,
  });

  // Converte um Map para ProdutosCompra
  factory ProdutosCompra.fromMap(Map<String, dynamic> map) {
    return ProdutosCompra(
      nome: map['nome'],
      quantidade: map['quantidade'],
      preco: map['preco'],
    );
  }

  // Converte ProdutosCompra para Map (opcional, para persistência)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'preco': preco,
    };
  }
}

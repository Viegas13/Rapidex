class ProdutosCompra {
  final int quantidade;
  final String nome;
  final double preco;

  ProdutosCompra({
    required this.quantidade,
    required this.nome,
    required this.preco,
  });

  Map<String, dynamic> toMap() {
    return {
      'quantidade': quantidade,
      'nome': nome,
      'preco': preco,
    };
  }

  @override
  String toString() {
    return 'Produto(nome: $nome, quantidade: $quantidade, preco: $preco)';
  }
}

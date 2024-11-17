class Produto {
  final String nome;
  final DateTime validade;
  final double preco;
  final String imagem;
  final String descricao;
  final String fornecedorCnpj;
  final bool restrito;

  Produto({
    required this.nome,
    required this.validade,
    required this.preco,
    required this.imagem,
    required this.descricao,
    required this.fornecedorCnpj,
    required this.restrito,
  });

  // Método para mapear o Produto para um formato que o banco de dados entenda
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'validade': validade.toIso8601String(),
      'preco': preco,
      'imagem': imagem,
      'descricao': descricao,
      'fornecedor': fornecedorCnpj,
      'restrito' : restrito.toString(),
    };
  }
}
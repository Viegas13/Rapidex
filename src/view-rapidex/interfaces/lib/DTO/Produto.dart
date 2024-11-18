class Produto {
  final String nome;
  final DateTime? validade;
  final double preco;
  final String imagem;
  final String descricao;
  final String fornecedorCnpj;
  final bool restrito;
  final int quantidade;

  Produto({
    required this.nome,
    required this.validade,
    required this.preco,
    required this.imagem,
    required this.descricao,
    required this.fornecedorCnpj,
    required this.restrito,
    required this.quantidade
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      nome: map['nome'] ?? '',
      validade: map['validade'] != null
          ? DateTime.tryParse(map['datanascimento'].toString()) // Garantir que a data está em DateTime
          : null,
      preco: map['preco'] ?? '',
      imagem: map['imagem'] ?? '',
      descricao: map['descricao'] ?? '',
      fornecedorCnpj: map['fornecedorCnpj'] ?? '',
      restrito: map['restrito'] ?? '',
      quantidade: map['quantidade'] ?? '',
    );
  }

  // Método para mapear o Produto para um formato que o banco de dados entenda
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'validade': validade?.toIso8601String(),
      'preco': preco,
      'imagem': imagem,
      'descricao': descricao,
      'fornecedor': fornecedorCnpj,
      'restrito' : restrito.toString(),
      'quantidade': quantidade,
    };
  }
}
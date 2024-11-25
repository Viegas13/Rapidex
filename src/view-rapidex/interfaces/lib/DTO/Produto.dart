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
    //  required this.imagem,
    required this.descricao,
    required this.fornecedorCnpj,
    required this.restrito,
    required this.quantidade,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      nome: map['nome'] ?? '',
      validade: map['validade'] != null
          ? DateTime.tryParse(map['validade'].toString())
          : null,
      preco: double.tryParse(map['preco'].toString()) ?? 0.0,
      // imagem: map['imagem'] ?? '',
      descricao: map['descricao'] ?? '',
      fornecedorCnpj: map['fornecedor_cnpj'] ?? '',
      restrito: map['restritoPorIdade'] == true ||
          map['restritoPorIdade'].toString() == 'true',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'validade': validade?.toIso8601String(),
      'preco': preco,
      //'imagem': imagem,
      'descricao': descricao,
      'fornecedor_cnpj': fornecedorCnpj,
      'restritoPorIdade': restrito.toString(),
      'quantidade': quantidade,
    };
  }
}

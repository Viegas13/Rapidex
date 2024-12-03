import 'dart:typed_data';

class Produto {
  final int produto_id;
  final String nome;
  final DateTime? validade;
  final double preco;
  final Uint8List? imagem;
  final String descricao;
  final String fornecedorCnpj;
  final bool restrito;
  final int quantidade;

  Produto({
    required this.produto_id,
    required this.nome,
    required this.validade,
    required this.preco,
    required this.imagem,
    required this.descricao,
    required this.fornecedorCnpj,
    required this.restrito,
    required this.quantidade,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      produto_id: int.tryParse(map['produto_id'].toString()) ?? 0, 
      nome: map['nome_produto'] ?? '', // Ajuste para usar o alias `nome_produto`
      validade: map['validade'] != null
          ? DateTime.tryParse(map['validade'].toString())
          : null,
      preco: double.tryParse(map['preco'].toString()) ?? 0.0,
      imagem: map['imagem'] != null
          ? Uint8List.fromList((map['imagem'] as List<int>))
          : null, // Permite imagens nulas,
      descricao: map['descricao'] ?? '',
      fornecedorCnpj: map['fornecedor_cnpj'] ?? '',
      restrito: map['restritoPorIdade'] == true ||
          map['restritoPorIdade'].toString() == 'true',
      quantidade: int.tryParse(map['quantidade'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'produto_id': produto_id,
      'nome': nome,
      'validade': validade?.toIso8601String(),
      'preco': preco,
      'imagem': imagem,
      'descricao': descricao,
      'fornecedor_cnpj': fornecedorCnpj,
      'restritoPorIdade': restrito.toString(),
      'quantidade': quantidade,
    };
  }
}

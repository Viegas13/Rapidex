class Fornecedor {
  final String cnpj;
  final String nome;
  final String email;
  final String senha;
  final String telefone;

  Fornecedor({

    required this.cnpj,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
  });

  // Método para criar o objeto Fornecedor a partir de um mapa de dados
  factory Fornecedor.fromMap(Map<String, dynamic> map) {
    return Fornecedor(
      cnpj: map['cnpj'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      telefone: map['telefone'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
    };
  }
}

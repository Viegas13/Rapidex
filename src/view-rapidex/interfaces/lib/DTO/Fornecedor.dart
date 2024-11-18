class Fornecedor {
  final String cnpj;
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  

  Fornecedor({
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.email,
    required this.senha,
  });

  factory Fornecedor.fromMap(Map<String, dynamic> map) {
    return Fornecedor(
      cnpj: map['cnpj'] ?? '', // Garantir que o CPF é uma String
      nome: map['nome'] ?? '',
      senha: map['senha'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
    );
  }

  // Método para mapear o Fornecedor para um formato que o banco de dados entenda
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
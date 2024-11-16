class Cliente {
  final String cnpj;
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  

  Cliente({
    required this.nome,
    required this.cnpj,
    required this.telefone,
    required this.email,
    required this.senha,
  });

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
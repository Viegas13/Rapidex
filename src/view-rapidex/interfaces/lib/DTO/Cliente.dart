class Cliente {
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final String senha;
  final DateTime dataNascimento;

  Cliente({
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.dataNascimento,
  });

  // Método de fábrica para criar um Cliente a partir de um Map
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      nome: map['nome'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      email: map['email'],
      senha: map['senha'],
      dataNascimento: map['datanascimento'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['datanascimento'])
          : DateTime.parse(map['datanascimento']),
    );
  }

  // Método para mapear o Cliente para um formato que o banco de dados entenda
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'datanascimento': dataNascimento.toIso8601String(),
    };
  }
}

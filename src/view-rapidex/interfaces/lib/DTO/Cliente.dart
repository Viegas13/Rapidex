class Cliente {
  final String cpf;
  final String nome;
  final String senha;
  final String email;
  final String telefone;
  final DateTime? dataNascimento;

  Cliente({
    required this.cpf,
    required this.nome,
    required this.senha,
    required this.email,
    required this.telefone,
    this.dataNascimento,
  });

  // Método para criar o objeto Cliente a partir de um mapa de dados
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cpf: map['cpf'] ?? '', // Garantir que o CPF é uma String
      nome: map['nome'] ?? '',
      senha: map['senha'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      dataNascimento: map['datanascimento'] != null
          ? DateTime.tryParse(map['datanascimento'].toString()) // Garantir que a data está em DateTime
          : null,
    );
  }

  // Método para mapear o objeto Cliente de volta para um mapa de dados
  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'nome': nome,
      'senha': senha,
      'email': email,
      'telefone': telefone,
      'datanascimento': dataNascimento?.toIso8601String(),
    };
  }
}

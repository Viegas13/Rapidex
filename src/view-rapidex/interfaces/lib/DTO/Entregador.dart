class Entregador {
  final String cpf;
  final String nome;
  final String senha;
  final String email;
  final String telefone;
  final DateTime? dataNascimento;

  Entregador({
    required this.cpf,
    required this.nome,
    required this.senha,
    required this.email,
    required this.telefone,
    this.dataNascimento,
  });

  // Método para criar o objeto Entregador a partir de um mapa de dados
  factory Entregador.fromMap(Map<String, dynamic> map) {
    return Entregador(
      cpf: map['cpf'].toString(), // Garantir que o CPF é uma String
      nome: map['nome'] ?? '',
      senha: map['senha'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      dataNascimento: map['datanascimento'] != null
          ? DateTime.tryParse(map['datanascimento'].toString()) // Garantir que a data está em DateTime
          : null,
    );
  }

  // Método para mapear o objeto Entregador de volta para um mapa de dados
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

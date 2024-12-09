class Cartao {
  final int numero;
  final int cvv;
  final DateTime validade;
  final String nomeTitular;
  final int agencia;
  final String bandeira;
  final String clienteCpf;
  final String cpf_titular;

  Cartao({
    required this.numero,
    required this.cvv,
    required this.validade,
    required this.nomeTitular,
    required this.agencia,
    required this.bandeira,
    required this.clienteCpf,
    required this.cpf_titular,
  });

  // Método para converter um objeto Cartao em um mapa (útil para inserções no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'cvv': cvv,
      'validade': validade,
      'nomeTitular': nomeTitular,
      'agencia': agencia,
      'bandeira': bandeira,
      'cliente_cpf': clienteCpf,
      'cpf_titular': cpf_titular,
    };
  }

  // Método para criar um objeto Cartao a partir de um mapa (útil para consultas no banco de dados)
  factory Cartao.fromMap(Map<String, dynamic> map) {
    return Cartao(
      numero: map['numero'] != null ? map['numero'] as int : 0, // Valor padrão para `numero`
      cvv: map['cvv'] != null ? map['cvv'] as int : 0, // Valor padrão para `cvv`
      validade: map['validade'] ?? DateTime.now(), // Assume que `validade` já é DateTime
      nomeTitular: map['nomeTitular'] ?? 'Sem Nome', // Texto padrão
      agencia: map['agencia'] != null ? map['agencia'] as int : 0, // Valor padrão para `agencia`
      bandeira: map['bandeira'] ?? 'Sem Bandeira', // Texto padrão
      clienteCpf: map['cliente_cpf'] ?? '', // Texto padrão vazio
      cpf_titular: map['cpf_titular'] ?? '', // Texto padrão vazio
    );
  }

}

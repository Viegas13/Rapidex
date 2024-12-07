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
      numero: map['numero'] as int,
      cvv: map['cvv'] as int,
      validade: map['validade'] as DateTime,
      nomeTitular: map['nomeTitular'] as String,
      agencia: map['agencia'] as int,
      bandeira: map['bandeira'] as String,
      clienteCpf: map['cliente_cpf'] as String,
      cpf_titular: map['cpf_titular'] as String,
    );
  }
}

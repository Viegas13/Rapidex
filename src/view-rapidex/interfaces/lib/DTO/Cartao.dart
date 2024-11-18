class Cartao {
  final String numero;
  final String nomeTitular;
  final String bandeira;
  final String cpfCliente;
  final String validade;
  final String codigoSeguranca;

  Cartao({
    required this.numero,
    required this.nomeTitular,
    required this.bandeira,
    required this.cpfCliente,
    required this.validade,
    required this.codigoSeguranca,
  });

  // Método para converter um objeto Cartao em um mapa (útil para inserções no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'nomeTitular': nomeTitular,
      'bandeira': bandeira,
      'cpfCliente': cpfCliente,
      'validade': validade,
      'codigoSeguranca': codigoSeguranca,
    };
  }

  // Método para criar um objeto Cartao a partir de um mapa (útil para consultas no banco de dados)
  factory Cartao.fromMap(Map<String, dynamic> map) {
    return Cartao(
      numero: map['numero'] as String,
      nomeTitular: map['nomeTitular'] as String,
      bandeira: map['bandeira'] as String,
      cpfCliente: map['cpfCliente'] as String,
      validade: map['validade'] as String,
      codigoSeguranca: map['codigoSeguranca'] as String,
    );
  }
}

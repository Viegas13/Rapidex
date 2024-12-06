class Endereco {
  final String cep;
  final String rua;
  final String bairro;
  final int numero;
  final String complemento;
  final String referencia;
  final String clienteCpf;

  Endereco({
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.complemento,
    required this.referencia,
    required this.clienteCpf,
  });

  String get enderecoId => '${cep}_$clienteCpf';

  Map<String, dynamic> toMap() {
    return {
      'endereco_id': enderecoId,
      'bairro': bairro,
      'rua': rua,
      'numero': numero.toString(),
      'cep': cep,
      'complemento': complemento,
      'referencia': referencia,
      'cliente_cpf': clienteCpf,
    };
  }
}

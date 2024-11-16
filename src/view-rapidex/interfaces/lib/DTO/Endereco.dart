class Endereco {
  final String cep;
  final String rua;
  final String bairro;
  final int numero;
  final String complemento;
  final String referencia;

  Endereco({
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.complemento,
    required this.referencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'bairro': bairro,
      'rua': rua,
      'numero': numero.toString(),
      'cep': cep,
      'complemento': complemento,
      'referencia': referencia,
      'cliente_cpf': '12345678900',
    };
  }
}
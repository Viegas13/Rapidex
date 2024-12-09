class Endereco {
  final String cep;
  final String rua;
  final String bairro;
  final int numero;
  final String complemento;
  final String referencia;
  final String? clienteCpf;
  final String? fornecedorCnpj;

  Endereco({
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.complemento,
    required this.referencia,
    this.clienteCpf,
    this.fornecedorCnpj,
  }) {
    if ((clienteCpf == null && fornecedorCnpj == null) ||
        (clienteCpf != null && fornecedorCnpj != null)) {
      throw ArgumentError(
          'Deve ser fornecido apenas um dos parâmetros: clienteCpf ou fornecedorCnpj.');
    }
  }

  String get enderecoId => clienteCpf != null
      ? '${cep}_$clienteCpf'
      : '${cep}_$fornecedorCnpj';

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
      'fornecedor_cnpj': fornecedorCnpj,
    };
  }
}

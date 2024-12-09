import 'package:intl/intl.dart';

class Pedido {
  int? pedido_id;
  String cliente_cpf;
  String fornecedor_cnpj;
  double preco;
  double frete;
  DateTime data_de_entrega;
  String endereco_entrega; // Novo campo
  String status_pedido;


  Pedido({
    this.pedido_id,
    required this.cliente_cpf,
    required this.fornecedor_cnpj,
    required this.preco,
    required this.frete,
    required this.data_de_entrega,
    required this.endereco_entrega,
    this.status_pedido = 'pendente',

  });

  // Conversão para map (para inserir no banco)
  Map<String, dynamic> toMap() {
    return {
      'pedido_id': pedido_id,
      'cliente_cpf': cliente_cpf,
      'fornecedor_cnpj': fornecedor_cnpj,
      'preco': preco,
      'frete': frete,
      'data_de_entrega':DateFormat('yyyy-MM-dd').format(data_de_entrega),
      'endereco_entrega': endereco_entrega,
      'status_pedido': status_pedido,

    };
  }

  // Conversão de map (ao buscar no banco)
    factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
    pedido_id: map['pedido_id'],
    cliente_cpf: map['cliente_cpf'],
    fornecedor_cnpj: map['fornecedor_cnpj'],
    preco: (map['preco'] as double?) ?? 0.0,
    frete: (map['frete'] as double?) ?? 0.0,
    data_de_entrega: map['data_de_entrega'] is String
      ? DateTime.parse(map['data_de_entrega']) // Caso venha como String
      : map['data_de_entrega'] ?? DateTime.now(), // Se for DateTime já, usa diretamente
    endereco_entrega: map['endereco_entrega'],
    status_pedido: map['status_pedido'] ?? 'pendente',
    // Garantir que a data seja um DateTime
    
    );
    }
}

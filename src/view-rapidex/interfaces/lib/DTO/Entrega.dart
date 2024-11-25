import 'package:interfaces/DTO/Status.dart';

class Entrega {
  final int pedidoId;
  final String cpf_entregador;
  final Status status;
  final String cliente_cpf;
  final String endereco;
  final double frete;

  Entrega({
    required this.pedidoId,
    required this.cpf_entregador,
    required this.status,
    required this.cliente_cpf,
    required this.endereco,
    required this.frete,
  });

  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      pedidoId: map['pedidoId'] ?? 0,
      cpf_entregador: map['cpf_entregador'] ?? '',
      status: Status.values
          .byName(map['status'] ?? 'em_espera'), // Assumindo um enum
      cliente_cpf: map['cliente_cpf'] ?? '',
      endereco: map['endereco'] ?? '',
      frete: double.tryParse(map['frete'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pedidoId': pedidoId,
      'cpf_entregador': cpf_entregador,
      'status': status.name, // Convertendo enum para string
      'cliente_cpf': cliente_cpf,
      'endereco': endereco,
      'frete': frete,
    };
  }
}

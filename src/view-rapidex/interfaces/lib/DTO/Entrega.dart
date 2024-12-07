import 'package:interfaces/DTO/Status.dart';

class Entrega {
  final int? entregaId;
  final int pedidoId;
  final String entregadorCPF;
  final Status status;
  final String enderecoRetirada;
  final String enderecoEntrega;
  final double valorFinal;

  Entrega({
    this.entregaId,
    required this.pedidoId,
    required this.entregadorCPF,
    required this.status,
    required this.enderecoRetirada,
    required this.enderecoEntrega,
    required this.valorFinal,
  });

  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      entregaId: map['entrega_id'] ?? 0,
      pedidoId: map['pedido_id'] ?? 0,
      entregadorCPF: map['entregador_cpf'] ?? '',
      status: Status.values
          .byName(map['status_entrega'] ?? 'aguardando_retirada'), // Assumindo um enum
      enderecoRetirada: map['endereco_retirada'] ?? '',
      enderecoEntrega: map['endereco_entrega'] ?? '',
      valorFinal: double.tryParse(map['valor_final'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entregaId': entregaId,
      'pedidoId': pedidoId,
      'entregadorCPF': entregadorCPF,
      'status': status.name, // Convertendo enum para string
      'enderecoRetirada': enderecoRetirada,
      'enderecoEntrega': enderecoEntrega,
      'valorFinal': valorFinal,
    };
  }
}

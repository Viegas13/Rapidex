import 'package:interfaces/DTO/Status.dart';

class Entrega {
  final int entregaId;
  final int pedidoId;
  final String entregadorCPF;
  final Status status;
  final String enderecoRetirada;
  final String enderecoEntrega;
  final double valorFinal;

  Entrega({
    required this.entregaId,
    required this.pedidoId,
    required this.entregadorCPF,
    required this.status,
    required this.enderecoRetirada,
    required this.enderecoEntrega,
    required this.valorFinal,
  });

  factory Entrega.fromMap(Map<String, dynamic> map) {
    return Entrega(
      entregaId: map['entregaId'] ?? 0,
      pedidoId: map['pedidoId'] ?? 0,
      entregadorCPF: map['entregadorCPF'] ?? '',
      status: Status.values
          .byName(map['status'] ?? 'em_espera'), // Assumindo um enum
      enderecoRetirada: map['enderecoRetirada'] ?? '',
      enderecoEntrega: map['enderecoEntrega'] ?? '',
      valorFinal: double.tryParse(map['valorFinal'].toString()) ?? 0.0,
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

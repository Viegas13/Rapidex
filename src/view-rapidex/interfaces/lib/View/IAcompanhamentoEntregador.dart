import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/DTO/Pedido.dart';
import 'package:interfaces/DTO/Status.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregaDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/PedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'dart:math';

class AcompanhamentoEntregadorScreen extends StatefulWidget {
  const AcompanhamentoEntregadorScreen({super.key});

  @override
  _AcompanhamentoEntregadorScreenState createState() =>
      _AcompanhamentoEntregadorScreenState();
}

class _AcompanhamentoEntregadorScreenState
    extends State<AcompanhamentoEntregadorScreen> {
  EntregadorDAO? entregadorDAO;
  EntregaDAO? entregaDAO;
  EnderecoDAO? enderecoDAO;
  PedidoDAO? pedidoDAO;

  SessionController sessionController = SessionController();

  Entregador? entregadorLogado;
  Entrega? entrega;
  String? cpfLogado;

  int countDeEstado = 0;
  String textoBotaoDeEstado = 'Notificar - A Caminho';

  Random random = new Random();
  late int randomTempo;

  late Future<void> entregaFuture = _initializeEntregaFuture();

  Future<void> _initializeEntregaFuture() async {
    final conexaoDB = ConexaoDB();

    try {
      await conexaoDB.initConnection();

      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      entregaDAO = EntregaDAO(conexaoDB: conexaoDB);
      pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);

      randomTempo = random.nextInt(35) + 25;

      await getEntregaVigente();
    } catch (error) {
      print('Erro ao inicializar entregaFuture: $error');
      rethrow;
    }
  }

  Future<void> getEntregaVigente() async {
    entregadorLogado = await entregadorDAO?.buscarEntregadorParaLogin(
        sessionController.email.toString(), sessionController.senha.toString());

    List<Status> status = [
      Status.aguardando_retirada,
      Status.a_caminho,
      Status.chegou
    ];

    cpfLogado = entregadorLogado!.cpf;

    entrega =
        await entregaDAO?.buscarEntregaPorEntregadorStatus2(cpfLogado!, status);

    setState(() {});
  }

  void changeTextEStatus() {
    setState(() {
      if (countDeEstado == 0) {
        textoBotaoDeEstado = "Notificar - Pedido Chegou";

        countDeEstado++;

        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.a_caminho);
        pedidoDAO?.atualizarStatusPedido(entrega?.pedidoId, 'retirado');
      } else if (countDeEstado == 1) {
        textoBotaoDeEstado = "Finalizar Entrega";

        countDeEstado++;

        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.chegou);
      } else {
        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.entregue);
        pedidoDAO?.atualizarStatusPedido(entrega?.pedidoId, 'concluido');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeEntregadorScreen()),
        );
      }
    });
  }

  Future<String?> getEnderecoFornecedor(String cnpj) async {
    final enderecoFornecedor =
        await enderecoDAO!.listarEnderecosFornecedor(cnpj);

    if (enderecoFornecedor.isNotEmpty) {
      return enderecoFornecedor[0]['rua'].toString() +
          ' ' +
          enderecoFornecedor[0]['numero'].toString() +
          ', ' +
          enderecoFornecedor[0]['bairro'].toString();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/mapa.png', // Caminho para a imagem
              fit: BoxFit.cover, // Ajusta a imagem ao tamanho da tela
            ),
          ),
          Center(
            child: FutureBuilder<void>(
              future: entregaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(
                    'Erro ao carregar dados',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                } else if (entrega == null) {
                  return const Text(
                    'Nenhuma entrega vigente encontrada',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Retirada: ${entrega!.enderecoRetirada}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Entrega: ${entrega!.enderecoEntrega}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tempo para Chegada: 00:${randomTempo}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                changeTextEStatus();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                              ),
                              child: Text(
                                textoBotaoDeEstado,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

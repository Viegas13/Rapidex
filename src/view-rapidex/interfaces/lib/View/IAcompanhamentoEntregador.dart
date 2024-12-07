import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/DTO/Status.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregaDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';

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

  SessionController sessionController = SessionController();

  Entregador? entregadorLogado;
  Entrega? entrega;
  String? cpfLogado;

  int countDeEstado = 0;
  String textoBotaoDeEstado = 'Notificar - A Caminho';

  late Future<void> entregaFuture = _initializeEntregaFuture();

  Future<void> _initializeEntregaFuture() async {
    final conexaoDB = ConexaoDB();

    try {
      await conexaoDB.initConnection();
      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      entregaDAO = EntregaDAO(conexaoDB: conexaoDB);
      await getEntregaVigente();
    } catch (error) {
      print('Erro ao inicializar entregaFuture: $error');
      rethrow;
    }
  }

  Future<void> getEntregaVigente() async {
    entregadorLogado = await entregadorDAO?.BuscarEntregadorParaLogin(
        sessionController.email.toString(),
        sessionController.senha.toString());

    List<Status> status = [Status.aguardando_retirada, Status.a_caminho, Status.chegou];

    cpfLogado = entregadorLogado!.cpf;

    entrega = await entregaDAO?.buscarEntregaPorEntregador3Status(
        cpfLogado!, status);

    setState(() {});
  }

   void changeTextEStatus() {
    setState(() {
      
      if (countDeEstado == 0) {
        textoBotaoDeEstado = "Notificar - Pedido Chegou";

        countDeEstado++;

        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.a_caminho);
      }
      else if (countDeEstado == 1) {
        textoBotaoDeEstado = "Finalizar Entrega";

        countDeEstado++;

        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.chegou);
      }
      else {
        entregaDAO?.atualizarStatusEntrega(cpfLogado!, Status.entregue);
        //await Future.delayed(Duration(seconds: 1));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeEntregadorScreen()),
        );
      }
       
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
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
                        const Text(
                          'Chegada: 00:00h',
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
    );
  }
}
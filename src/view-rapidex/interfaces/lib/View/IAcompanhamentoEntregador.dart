import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/DTO/Status.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregaDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/CustomTextField.dart';

class AcompanhamentoEntregadorScreen extends StatefulWidget {
  const AcompanhamentoEntregadorScreen({super.key});

  @override
  _AcompanhamentoEntregadorScreenState createState() => _AcompanhamentoEntregadorScreenState();
}

class _AcompanhamentoEntregadorScreenState extends State<AcompanhamentoEntregadorScreen> {

  late ConexaoDB conexaoDB;
  late EntregaDAO entregaDAO;
  late EntregadorDAO entregadorDAO;
  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();

    conexaoDB = ConexaoDB();
    entregaDAO = EntregaDAO(conexaoDB: conexaoDB);
    entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<Entrega?> getEntregaVigente() async {
    Entregador? entregadorLogado = await entregadorDAO.BuscarEntregadorParaLogin(sessionController.email.toString(), sessionController.senha.toString());
    Status status = Status.aguardando_retirada;

    return entregaDAO.buscarEntregaPorEntregadorStatus(entregadorLogado!.cpf, status);
  }

  Future<String> getEnderecoRetirada() async {
    try {
      Entrega? entrega = await getEntregaVigente();

      if (entrega != null) {
        return entrega.enderecoRetirada;
      } else {
        throw Exception('Nenhuma entrega vigente encontrada.');
      }
    } catch (e) {
      print('Erro ao obter o endereço de retirada: $e');
      rethrow;
    }
  }

  Future<String> getEnderecoEntrega() async {
    try {
      Entrega? entrega = await getEntregaVigente();

      if (entrega != null) {
        return entrega.enderecoEntrega;
      } else {
        throw Exception('Nenhuma entrega vigente encontrada.');
      }
    } catch (e) {
      print('Erro ao obter o endereço de retirada: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Cor do fundo laranja
      body: Center(
        child: Column(
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
                  const Text(
                    'Retirada: {$getEnderecoRetirada()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Destino: {$}',
                    style: TextStyle(
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
                      // Lógica para confirmar recebimento ou entrega
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recebimento confirmado!')),
                      );
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
                    child: const Text(
                      'Confirmar Recebimento/Entrega',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

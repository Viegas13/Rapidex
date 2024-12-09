import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/DTO/Status.dart';
import 'package:interfaces/View/IHomeEntregador.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregaDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';

class MinhasEntregasScreen extends StatefulWidget {
  const MinhasEntregasScreen({super.key});

  @override
  _MinhasEntregasScreenState createState() =>
      _MinhasEntregasScreenState();
}

class _MinhasEntregasScreenState extends State<MinhasEntregasScreen> {
  EntregadorDAO? entregadorDAO;
  EntregaDAO? entregaDAO;
  Entregador? entregadorLogado;
  String? cpfLogado;
  
  SessionController sessionController = SessionController();

  Future<List<Entrega>>? entregasFeitasFuture;

  void initState() {
    super.initState();

    final conexaoDB = ConexaoDB();

    conexaoDB.initConnection().then((_) {
      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      entregaDAO = EntregaDAO(conexaoDB: conexaoDB);

      setEntregadorCPF().then((_) {
        setState(() {
          entregasFeitasFuture = entregaDAO?.buscarEntregasPorEntregadorStatus(cpfLogado!, Status.entregue);
        });
      });

      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  Future<void> setEntregadorCPF() async {
    entregadorLogado = await entregadorDAO?.BuscarEntregadorParaLogin(
      sessionController.email.toString(),
      sessionController.senha.toString(),
    );

    cpfLogado = entregadorLogado!.cpf;
    print(cpfLogado);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Entregas"),
        backgroundColor: Colors.white, 
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Ícone da seta de voltar
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeEntregadorScreen()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.orange, 
        child: FutureBuilder<List<Entrega>>(
          future: entregasFeitasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma entrega encontrada.'));
            }

            final entregasFeitas = snapshot.data!;

            return ListView.builder(
              itemCount: entregasFeitas.length,
              itemBuilder: (context, index) {
                final entrega = entregasFeitas[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Entrega Nº: ${index + 1}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Endereço do Fornecedor: ${entrega.enderecoRetirada}"),
                        const SizedBox(height: 4),
                        Text("Endereço de Entrega: ${entrega.enderecoEntrega}"),
                        const SizedBox(height: 4),
                        Text(
                          "Valor recebido: R\$ ${(entrega.valorFinal * 0.05).toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Endereco.dart';
import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Entregador.dart';
import 'package:interfaces/DTO/Pedido.dart';
import 'package:interfaces/DTO/Status.dart';
import 'package:interfaces/View/IAcompanhamentoEntregador.dart';
import 'package:interfaces/View/IMinhasEntregas.dart';
import 'package:interfaces/View/IPerfilEntregador.dart';
import 'package:interfaces/View/Icarrinho.dart';
import 'package:interfaces/View/IMap.dart';
import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregaDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/EntregadorDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/PedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/widgets/Item.dart';

class HomeEntregadorScreen extends StatefulWidget {
  const HomeEntregadorScreen({super.key});

  @override
  State<HomeEntregadorScreen> createState() => _HomeEntregadorScreenState();
}

class _HomeEntregadorScreenState extends State<HomeEntregadorScreen> {
  EntregaDAO? entregaDAO;
  Entregador? entregadorLogado;
  EntregadorDAO? entregadorDAO;
  PedidoDAO? pedidoDAO;
  FornecedorDAO? fornecedorDAO;
  EnderecoDAO? enderecoDAO;

  String? cpfLogado;

  SessionController sessionController = SessionController();

  Future<List<Pedido>>? pedidosDisponiveisFuture;

  @override
  void initState() {
    super.initState();
    final conexaoDB = ConexaoDB();

    conexaoDB.initConnection().then((_) {
      entregadorDAO = EntregadorDAO(conexaoDB: conexaoDB);
      entregaDAO = EntregaDAO(conexaoDB: conexaoDB);
      pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);

      setEntregadorCPF().then((_) {
        setState(() {
          pedidosDisponiveisFuture =
              pedidoDAO?.buscarPedidosDisponiveisEntrega();
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

  Future<String?> getNomeFornecedor(String cnpj) async {
    return await fornecedorDAO!.buscarNomeFornecedor(cnpj);
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

  Future<void> alterarStatusPedido(int idPedido, String status) async {
    await pedidoDAO!.atualizarStatusPedido(idPedido, status);
  }

  Future<void> criarEntregaPeloPedido(
      int novoIdPedido,
      String novoEntregadorCPF,
      String novoEnderecoRetirada,
      String novoEnderecoEntrega,
      double novoValorFinal) async {
    Entrega novaEntrega = Entrega(
        pedidoId: novoIdPedido,
        entregadorCPF: novoEntregadorCPF,
        status: Status.aguardando_retirada,
        enderecoRetirada: novoEnderecoRetirada,
        enderecoEntrega: novoEnderecoEntrega,
        valorFinal: novoValorFinal);

    await entregaDAO!.cadastrarEntrega(novaEntrega);
  }

  Future<String?> getEnderecoEntrega(String chaveCepCpf) async {
    String? cep = chaveCepCpf.substring(1, 9);
    String? cpf = chaveCepCpf.substring(9);

    final enderecoEntrega = await enderecoDAO!.getEnderecoCepCpf(cpf, cep);

    print(cep);
    print(cpf);
    print(enderecoEntrega.isNotEmpty);

    if (enderecoEntrega.isNotEmpty) {
      return enderecoEntrega[0]['rua'].toString() +
          ', ' +
          enderecoEntrega[0]['numero'].toString() +
          ', ' +
          enderecoEntrega[0]['bairro'].toString();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior com perfil, "Minhas Entregas"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.grey),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilEntregadorScreen(),
                      ),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MinhasEntregasScreen()),
                    );
                  },
                  child: const Text(
                    "Minhas Entregas",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Opções de Entrega",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Pedido>>(
                future: pedidosDisponiveisFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar entregas: ${snapshot.error}',
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhuma entrega disponível.'));
                  }

                  final pedidos = snapshot.data!;

                  return ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];

                      return FutureBuilder<String?>(
                        future: getNomeFornecedor(pedido.fornecedor_cnpj),
                        builder: (context, fornecedorSnapshot) {
                          if (fornecedorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Carregando fornecedor..."),
                            );
                          }

                          if (fornecedorSnapshot.hasError) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text("Erro ao carregar fornecedor."),
                            );
                          }

                          final nomeFornecedor = fornecedorSnapshot.data ??
                              "Fornecedor não encontrado";

                          return FutureBuilder<String?>(
                            future:
                                getEnderecoFornecedor(pedido.fornecedor_cnpj),
                            builder: (context, enderecoSnapshot) {
                              if (enderecoSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      "Carregando endereço de retirada..."),
                                );
                              }

                              if (enderecoSnapshot.hasError) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      "Erro ao carregar endereço de retirada."),
                                );
                              }

                              final enderecoRetirada = enderecoSnapshot.data ??
                                  "Endereço de retirada não encontrado";

                              // Adicionando o FutureBuilder para o endereço de entrega
                              return FutureBuilder<String?>(
                                future:
                                    getEnderecoEntrega(pedido.endereco_entrega),
                                builder: (context, enderecoEntregaSnapshot) {
                                  if (enderecoEntregaSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                          "Carregando endereço de entrega..."),
                                    );
                                  }

                                  if (enderecoEntregaSnapshot.hasError) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                          "Erro ao carregar endereço de entrega."),
                                    );
                                  }

                                  final enderecoEntrega =
                                      enderecoEntregaSnapshot.data ??
                                          "Endereço de entrega não encontrado";

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  nomeFornecedor,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Retirada: $enderecoRetirada",
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Entrega: $enderecoEntrega", // Exibe o endereço de entrega
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "Valor: R\$ ${pedido.frete.toStringAsFixed(2)}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Botão "Aceitar" abaixo do texto
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              alterarStatusPedido(
                                                  pedido.pedido_id!, 'aceito');
                                              criarEntregaPeloPedido(
                                                  pedido.pedido_id!,
                                                  cpfLogado!,
                                                  enderecoRetirada,
                                                  enderecoEntrega,
                                                  pedido.preco);

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      //const AcompanhamentoEntregadorScreen(),
                                                      AcompanhamentoEntregadorScreen(enderecoFornecedor: enderecoRetirada, enderecoCliente: enderecoEntrega),
                                                ),
                                              );
                                            },
                                            child: const Text("Aceitar"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

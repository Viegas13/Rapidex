import 'package:flutter/material.dart';
import 'package:interfaces/DTO/Cartao.dart';
import 'ICadastroCartao.dart';
import '../banco_de_dados/DBHelper/ConexaoDB.dart';
import '../banco_de_dados/DAO/CartaoDAO.dart';
import '../controller/PedidoController.dart';

class FinalizarPedidoPage extends StatefulWidget {
  final List<Map<String, dynamic>> produtos;

  const FinalizarPedidoPage({Key? key, required this.produtos}) : super(key: key);

  @override
  _FinalizarPedidoPageState createState() => _FinalizarPedidoPageState();
}

class _FinalizarPedidoPageState extends State<FinalizarPedidoPage> {
  final PedidoController pedidoController = PedidoController();
  String? formaPagamento;
  String? cartaoSelecionado;
  late ConexaoDB conexaoDB;
  late CartaoDAO cartaoDAO;
  late List<Cartao> cartoes = [];

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    cartaoDAO = CartaoDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      carregarCartoes();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> carregarCartoes() async {
    try {
      String cpfCliente = '02083037669'; // Substitua pelo CPF do cliente logado
      cartoes = await cartaoDAO.buscarCartoesPorCliente(cpfCliente);
      if (cartoes.isNotEmpty) {
        cartaoSelecionado = cartoes[0].bandeira;
      }
      setState(() {});
    } catch (e) {
      print('Erro ao carregar cartões: $e');
    }
  }

  Widget selecionarCartao() {
    if (cartoes.isEmpty) {
      return const Text('Nenhum cartão cadastrado.');
    }

    return DropdownButton<String>(
      value: cartaoSelecionado,
      onChanged: (String? novoCartao) {
        setState(() {
          cartaoSelecionado = novoCartao!;
        });
      },
      items: cartoes.map((cartao) {
        return DropdownMenuItem<String>(
          value: cartao.numero.toString(),
          child: Text(
            '${cartao.nomeTitular} - ${cartao.bandeira}',
          ),
        );
      }).toList(),
    );
  }

  Future<void> finalizarPedido() async {
    if (formaPagamento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma forma de pagamento.')),
      );
      return;
    }

    if (formaPagamento == 'Cartão' && cartaoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cartão cadastrado.')),
      );
      return;
    }

    try {
      pedidoController.processarPedido(widget.produtos);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido finalizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao finalizar o pedido.')),
      );
      print('Erro ao finalizar o pedido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Finalizar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Produtos no Pedido:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.produtos.map((produto) {
              return Text(
                "${produto['nome']} - Quantidade: ${produto['quantidade']} - Total: R\$ ${(produto['quantidade'] * produto['preco']).toStringAsFixed(2)}",
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Forma de Pagamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              hint: const Text('Selecione a forma de pagamento'),
              value: formaPagamento,
              onChanged: (value) {
                setState(() {
                  formaPagamento = value;
                  if (formaPagamento != 'Cartão') {
                    cartaoSelecionado = null;
                  }
                });
              },
              items: ['Dinheiro', 'Cartão']
                  .map((forma) => DropdownMenuItem(
                        value: forma,
                        child: Text(forma),
                      ))
                  .toList(),
            ),
            if (formaPagamento == 'Cartão') ...[
              const SizedBox(height: 16),
              const Text(
                'Selecione um Cartão:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              selecionarCartao(),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroCartaoScreen()),
                  );
                  carregarCartoes();
                },
                child: const Text('Cadastrar Novo Cartão'),
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: finalizarPedido,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Finalizar Pedido',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

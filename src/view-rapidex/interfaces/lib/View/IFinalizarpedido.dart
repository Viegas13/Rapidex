  import 'package:flutter/material.dart';
  import 'package:interfaces/DTO/Cartao.dart';
  import 'package:interfaces/DTO/Produto.dart';
  import 'package:interfaces/banco_de_dados/DAO/EnderecoDAO.dart';
  import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';
  import 'package:interfaces/banco_de_dados/DAO/ItemPedidoDAO.dart';
  import 'package:interfaces/banco_de_dados/DAO/ClienteDAO.dart';
  import 'package:interfaces/controller/SessionController.dart';
  import 'package:interfaces/widgets/DropdownTextField.dart';
  import 'package:interfaces/widgets/Item.dart';
  import 'package:intl/intl.dart';
  import '../banco_de_dados/DAO/PedidoDAO.dart';
  import '../banco_de_dados/DAO/ItemPedidoDAO.dart';
  import 'ICadastroCartao.dart';
  import '../banco_de_dados/DBHelper/ConexaoDB.dart';
  import '../banco_de_dados/DAO/CartaoDAO.dart';
  import 'package:interfaces/DTO/ItemPedido.dart';
  import '../controller/PedidoController.dart';
  import 'package:interfaces/DTO/Pedido.dart';
  import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
  class FinalizarPedidoPage extends StatefulWidget {
    final List<ItemPedido> produtos;
    

    const FinalizarPedidoPage({Key? key, required this.produtos})
        : super(key: key);

    @override
    _FinalizarPedidoPageState createState() => _FinalizarPedidoPageState();
  }

  class _FinalizarPedidoPageState extends State<FinalizarPedidoPage> {
    final PedidoController pedidoController = PedidoController();
    final TextEditingController enderecoController = TextEditingController();
    final TextEditingController dataEntregaController = TextEditingController();
    String? formaPagamento;
    String? cartaoSelecionado;
    late ConexaoDB conexaoDB;
    late CartaoDAO cartaoDAO;
    late PedidoDAO pedidoDAO;
    late ProdutoDAO produtoDAO;
    DateTime? dataEntrega;
    late ClienteDAO clienteDAO;
    late ItemPedidoDAO itemPedidoDAO;
    late FornecedorDAO fornecedorDAO;
    late EnderecoDAO enderecoDAO;
    late String cep;
    List<String> enderecosFormatados = ['Carregando...'];
    late String cpf_cliente;
    SessionController sessionController = SessionController();
    List<Cartao> cartoes = [];
    bool isLoading = false;

    @override
    void initState() {
      super.initState();
      conexaoDB = ConexaoDB();
      cartaoDAO = CartaoDAO(conexaoDB: conexaoDB);
      clienteDAO = ClienteDAO(conexaoDB: conexaoDB);
      pedidoDAO = PedidoDAO(conexaoDB: conexaoDB);
      produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);
      itemPedidoDAO = ItemPedidoDAO(conexaoDB: conexaoDB);
      conexaoDB.initConnection().then((_) {
      enderecoDAO = EnderecoDAO(conexaoDB: conexaoDB);
        inicializarDados();
        buscarEnderecos();

      }).catchError((error) {
        print('Erro ao inicializar conexão: $error');
      });
    }

    Future<void> inicializarDados() async {
    try {
    cpf_cliente = await clienteDAO.buscarCpf(sessionController.email, sessionController.senha) ?? '';
    if (cpf_cliente.isEmpty) {
      throw Exception('CPF não encontrado para o email e senha fornecidos.');
    }
    await buscarEnderecos();
    carregarCartoes();
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    }
    }

    Future<void> carregarCartoes() async {
      setState(() {
        isLoading = true; // Exibe carregamento
      });

      try {
        String cpfCliente = cpf_cliente; // Substitua pelo CPF do cliente logado
        cartoes = await cartaoDAO.buscarCartoesPorCliente(cpfCliente);

        if (cartoes.isNotEmpty) {
          // Verifica se o número do cartão não é nulo antes de converter para string
          cartaoSelecionado = cartoes[0].numero.toString();
        } else {
          cartaoSelecionado = null; // Nenhum cartão disponível
        }
      } catch (e) {
        print('Erro ao carregar cartões: $e');
      } finally {
        setState(() {
          isLoading = false; // Finaliza carregamento
        });
      }
    }
    
    Future<void> buscarEnderecos() async {
    try {
      final enderecos = await enderecoDAO.listarEnderecosCliente(cpf_cliente);
      setState(() {
        enderecosFormatados = enderecos.map((endereco) {
          final complemento = endereco['complemento']?.isNotEmpty == true
              ? ', ${endereco['complemento']}'
              : '';
          final referencia = endereco['referencia']?.isNotEmpty == true
              ? ' (${endereco['referencia']})'
              : '';
          return 'CEP: ${endereco['cep']}, ${endereco['rua']} ${endereco['numero']}, ${endereco['bairro']} $complemento $referencia'
              .trim();
        }).toList();
        print('Endenreços encontrados');
      });

    } catch (e) {
      print('Erro ao buscar endereços: $e');
    }
  }
    Future<void> selecionarDataEntrega() async {
    DateTime? Selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (Selecionada != null) {
       setState(() {
          dataEntrega = Selecionada;
          // Atualiza o controlador para exibir a data de forma legível
          dataEntregaController.text = "${dataEntrega!.day.toString().padLeft(2, '0')}/"
              "${dataEntrega!.month.toString().padLeft(2, '0')}/"
              "${dataEntrega!.year}";
        });
      }
    }

   Widget selecionarCartao() {
  if (isLoading) {
    return const CircularProgressIndicator(); // Indicador de carregamento
  }

  if (cartoes.isEmpty) {
    return const Text('Nenhum cartão cadastrado.');
  }

  return DropdownButton<String>(
    value: cartaoSelecionado,
    onChanged: (String? novoCartao) {
      setState(() {
        cartaoSelecionado = novoCartao ?? '';
      });
    },
    items: List.generate(cartoes.length, (index) {
      final cartao = cartoes[index];
      final numeroCartao = cartao.numero.toString();
      final cpfTitular = cartao.cpf_titular ?? 'CPF do titular nao encotnrado';
      final bandeira = cartao.bandeira ?? 'Sem Bandeira';

      return DropdownMenuItem<String>(
        value: numeroCartao,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CPF titular: $cpfTitular - Bandeira: $bandeira',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (index < cartoes.length - 1) // Evita o tracejado no último item
              const Divider(
                thickness: 1,
                height: 8,
                color: Colors.grey,
                indent: 4,
                endIndent: 4,
              ),
          ],
        ),
      );
    }),
  );
}


    Future<void> finalizarPedido() async {
      try {
        double precoTotal = widget.produtos.fold(
          0, (soma, produto) => soma + produto.valorTotal,
        );

        DateTime dataParaEntrega = dataEntrega ?? DateTime.now();

        Pedido pedido = Pedido(
          cliente_cpf: cpf_cliente,
          fornecedor_cnpj: '',
          endereco_entrega: '$cep$cpf_cliente',
          preco: precoTotal, 
          frete: precoTotal * 0.01,
          data_de_entrega: dataParaEntrega,
        );

        final Iproduto = await produtoDAO.buscarProduto(widget.produtos.first.produtoId);
        if (Iproduto != null) {
          pedido.fornecedor_cnpj = Iproduto.fornecedorCnpj;
          }
        await pedidoDAO.cadastrarPedido(pedido);

        List<Pedido> listaDePedidos = await pedidoDAO.buscarPedidosPorCliente(pedido.cliente_cpf);
        Pedido ultimoPedido = listaDePedidos.last; // Último pedido cadastrado

        // Atualizar pedidoId de cada produto e persistir no banco
        widget.produtos.forEach((produto) async {
          produto.pedidoId = ultimoPedido.pedido_id!; // Atualiza pedidoId
          itemPedidoDAO.atualizarIDItemPedido(produto.itemPedidoId, produto.pedidoId); // Atualiza no banco de dados
          print('pedidoID atualizado para produto '); // Verifica no log
          
        });
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
                  " Quantidade: ${produto.quantidade} - Total: R\$ ${(produto.valorTotal).toStringAsFixed(2)}",
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
                Row(
                  children: [
                    const Text(
                      'Selecione um Cartão:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: carregarCartoes, // Botão de refresh
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                selecionarCartao(),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroCartaoScreen()),
                    );
                    carregarCartoes();
                  },
                  child: const Text('Cadastrar Novo Cartão'),
                ),
              ],
              const SizedBox(height: 24),
              DropdownTextField(
                    labelText: 'Endereço',
                    controller: enderecoController,
                    items: enderecosFormatados.isNotEmpty &&
                            enderecosFormatados[0] != 'Carregando...'
                        ? enderecosFormatados
                        : ['Nenhum endereço disponível'],
                    onItemSelected: (selectedValue) {
                      setState(() {
                        enderecoController.text = selectedValue;
                        cep = selectedValue.substring(4,13);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data de Entrega:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: selecionarDataEntrega,
                  child: const Text('Selecionar Data'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dataEntregaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Deixe em branco para efetuar entrega hoje',
                border: OutlineInputBorder(),
              ),
            ),
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

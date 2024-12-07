import 'package:flutter/material.dart';
import 'package:interfaces/DTO/ItemPedido.dart';
import 'package:interfaces/banco_de_dados/DAO/ItemPedidoDAO.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import '../DTO/Produto.dart';

class DetalhesProdutoBottomSheet extends StatefulWidget {
  final Produto produtoSelecionado;
  final List<Produto> produtosCategoria;
  final List<Produto>
      produtosFornecedor; // Lista de todos os produtos do fornecedor

  const DetalhesProdutoBottomSheet({
    Key? key,
    required this.produtoSelecionado,
    required this.produtosCategoria,
    required this.produtosFornecedor,
  }) : super(key: key);

  @override
  State<DetalhesProdutoBottomSheet> createState() =>
      _DetalhesProdutoBottomSheetState();
}

class _DetalhesProdutoBottomSheetState
    extends State<DetalhesProdutoBottomSheet> {
  late ConexaoDB conexaoDB;
  late ItemPedidoDAO itemPedidoDAO;

  @override
  void initState() {
    super.initState();
    conexaoDB = ConexaoDB();
    itemPedidoDAO = ItemPedidoDAO(conexaoDB: conexaoDB);

    conexaoDB.initConnection().then((_) {
      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  int quantidadeSelecionada = 1;

  void _incrementarQuantidade() {
    setState(() {
      if (quantidadeSelecionada < widget.produtoSelecionado.quantidade) {
        quantidadeSelecionada++;
      }
    });
  }

  void _decrementarQuantidade() {
    setState(() {
      if (quantidadeSelecionada > 1) {
        quantidadeSelecionada--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título e botão de fechar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.produtoSelecionado.nome,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Detalhes do produto
            _buildDetalhesProduto(),
            const SizedBox(height: 16),
            // Produtos relacionados
            if (widget.produtosCategoria.isNotEmpty)
              _buildProdutosRelacionados(context),
            const SizedBox(height: 16),
            // Todos os produtos do fornecedor
            _buildProdutosDoFornecedor(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalhesProduto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preço: R\$ ${widget.produtoSelecionado.preco.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (widget.produtoSelecionado.validade != null)
          Text(
            "Validade: ${_formatarData(widget.produtoSelecionado.validade!)}",
            style: const TextStyle(fontSize: 16),
          ),
        const SizedBox(height: 8),
        Text(
          "Descrição: ${widget.produtoSelecionado.descricao}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Fornecedor: ${widget.produtoSelecionado.fornecedorCnpj}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "Quantidade disponível: ${widget.produtoSelecionado.quantidade}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        // Botões de quantidade
        Row(
          children: [
            IconButton(
              onPressed: _decrementarQuantidade,
              icon: const Icon(Icons.remove, color: Colors.orange),
            ),
            Text(
              quantidadeSelecionada.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: _incrementarQuantidade,
              icon: const Icon(Icons.add, color: Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: quantidadeSelecionada > 0
              ? () async {
                  try {
                    final produtoSelecionado = widget.produtoSelecionado;

                    // Calculando o valor total
                    final valorTotal =
                        produtoSelecionado.preco * quantidadeSelecionada;

                    //DEBUGANDO
                    print("DEBUGANDO:");
                    print(produtoSelecionado.produto_id);
                    print(quantidadeSelecionada);
                    print(valorTotal);
                    print("FIM DO UDEBUG");

                    // Criando o mapa com os dados do ItemPedido
                    Map<String, dynamic> itemPedido = {
                      'produto_id': produtoSelecionado.produto_id,
                      'pedido_id': null, // Pedido ainda não associado
                      'quantidade': quantidadeSelecionada,
                      'valor_total': valorTotal,
                      'cliente_cpf': '70275182606', // CPF fixo até refatorar com a sessão
                    };

                    // Inserindo o ItemPedido no banco de dados
                    await itemPedidoDAO.cadastrarItemPedido(itemPedido);

                    // Feedback positivo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Item "${produtoSelecionado.nome}" adicionado ao carrinho com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    // Captura de erros e feedback negativo
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Erro ao adicionar o item "${widget.produtoSelecionado.nome}" ao carrinho.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              : null, // Desativa o botão se a quantidade for <= 0
          style: ElevatedButton.styleFrom(
            backgroundColor: quantidadeSelecionada > 0
                ? Colors.orange
                : Colors.grey, // Cor do botão muda quando desativado
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: const Text(
            "Adicionar ao Carrinho",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProdutosRelacionados(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Produtos Relacionados:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.produtosCategoria.length,
            itemBuilder: (context, index) {
              final produto = widget.produtosCategoria[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return DetalhesProdutoBottomSheet(
                        produtoSelecionado: produto,
                        produtosCategoria: widget.produtosCategoria,
                        produtosFornecedor: widget.produtosFornecedor,
                      );
                    },
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagem do produto (substituir caso necessário)
                      Container(
                        height: 80,
                        color: Colors.grey.withOpacity(0.3),
                        child: const Icon(Icons.image, size: 40),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        produto.nome,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "R\$ ${produto.preco.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProdutosDoFornecedor(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Outros produtos do fornecedor:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.produtosFornecedor.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Exibe 2 itens por linha
            childAspectRatio: 3 / 4, // Ajusta proporção dos itens
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final produto = widget.produtosFornecedor[index];
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return DetalhesProdutoBottomSheet(
                      produtoSelecionado: produto,
                      produtosCategoria: widget.produtosCategoria,
                      produtosFornecedor: widget.produtosFornecedor,
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem do produto (substituir caso necessário)
                    Container(
                      height: 80,
                      color: Colors.grey.withOpacity(0.3),
                      child: const Icon(Icons.image, size: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      produto.nome,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "R\$ ${produto.preco.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatarData(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}

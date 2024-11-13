import 'package:flutter/material.dart';

class FinalizarPedidoPage extends StatefulWidget {
  // Recebe os dados do carrinho como parâmetros
  final List<Map<String, dynamic>> produtos;
  final double frete;
  final double subtotal;

  FinalizarPedidoPage({
    required this.produtos,
    required this.frete,
    required this.subtotal,
  });

  @override
  _FinalizarPedidoPageState createState() => _FinalizarPedidoPageState();
}

class _FinalizarPedidoPageState extends State<FinalizarPedidoPage> {
  // Valores dos dropdowns
  String? enderecoSelecionado;
  String? metodoPagamentoSelecionado;

  @override
  Widget build(BuildContext context) {
    // Filtra apenas produtos com quantidade maior que 0
    List<Map<String, dynamic>> produtosFiltrados =
        widget.produtos.where((produto) {
      return produto['quantidade'] > 0;
    }).toList();

    double total = widget.subtotal + widget.frete;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Finalizar Pedido"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Resumo do Pedido",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Mostra os produtos com quantidade maior que 0
            ...produtosFiltrados.map((produto) {
              return Text(
                "${produto['nome']} - Quantidade: ${produto['quantidade']} - Total: R\$ ${(produto['quantidade'] * produto['preco']).toStringAsFixed(2)}",
              );
            }).toList(),

            SizedBox(height: 20),
            Divider(),
            Text(
              "Frete: R\$ ${widget.frete.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Subtotal: R\$ ${widget.subtotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Total: R\$ ${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // Campo de seleção do endereço
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Endereço"),
              items: [
                DropdownMenuItem(
                  value: "Endereço 1",
                  child: Text("Endereço 1"),
                ),
                DropdownMenuItem(
                  value: "Endereço 2",
                  child: Text("Endereço 2"),
                ),
                DropdownMenuItem(
                  value: "Endereço 3",
                  child: Text("Endereço 3"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  enderecoSelecionado = value;
                });
              },
              value: enderecoSelecionado,
            ),

            SizedBox(height: 20),

            // Campo de seleção do método de pagamento
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Método de Pagamento"),
              items: [
                DropdownMenuItem(
                  value: "Pix",
                  child: Text("Pix"),
                ),
                DropdownMenuItem(
                  value: "Cartão",
                  child: Text("Cartão"),
                ),
                DropdownMenuItem(
                  value: "Dinheiro",
                  child: Text("Dinheiro"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  metodoPagamentoSelecionado = value;
                });
              },
              value: metodoPagamentoSelecionado,
            ),

            // Botão para adicionar cartão (mostrado somente se a opção "Cartão" for selecionada)
            if (metodoPagamentoSelecionado == "Cartão")
              TextButton(
                onPressed: () {
                  // Lógica para adicionar cartão
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Adicionar Cartão"),
                      content: Text(
                          "Aqui você pode adicionar um novo cartão de crédito."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Fechar"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("Adicionar Cartão"),
              ),

            Spacer(),

            ElevatedButton(
              onPressed: () {
                // Lógica para finalizar o pedido
                if (enderecoSelecionado != null &&
                    metodoPagamentoSelecionado != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Pedido Finalizado"),
                      content: Text("Seu pedido foi realizado com sucesso!"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Fecha o diálogo
                            Navigator.pop(
                                context); // Retorna para a tela anterior
                          },
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Selecione um endereço e um método de pagamento.")),
                  );
                }
              },
              child: Text("Confirmar Pedido"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

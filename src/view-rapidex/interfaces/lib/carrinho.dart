import 'package:flutter/material.dart';
import 'finalizarpedido.dart';

class CarrinhoPage extends StatefulWidget {
  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  // Quantidade e preço dos produtos
  List<int> quantities = [0, 0, 0, 0];
  List<double> prices = [10.0, 20.0, 30.0, 40.0];

  // Variáveis para frete e subtotal
  double shipping = 0.0;
  double subtotal = 0.0;

  void updateValues() {
    subtotal = 0.0;
    shipping = 0.0;
    for (int i = 0; i < quantities.length; i++) {
      shipping += quantities[i] * 0.10;
      subtotal += (quantities[i] * prices[i]);
    }
    subtotal += shipping;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Carrinho"),
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
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quantities.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text("Produto ${index + 1}"),
                      subtitle: Text("Quantidade: ${quantities[index]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("R\$ ${prices[index].toStringAsFixed(2)}"),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                quantities[index]++;
                                updateValues();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantities[index] > 0) {
                                  quantities[index]--;
                                  updateValues();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Frete: R\$ ${shipping.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Subtotal: R\$ ${subtotal.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalizarPedidoPage(
                      produtos: [
                        {
                          'nome': 'Produto 1',
                          'quantidade': quantities[0],
                          'preco': prices[0]
                        },
                        {
                          'nome': 'Produto 2',
                          'quantidade': quantities[1],
                          'preco': prices[1]
                        },
                        {
                          'nome': 'Produto 3',
                          'quantidade': quantities[2],
                          'preco': prices[2]
                        },
                        {
                          'nome': 'Produto 4',
                          'quantidade': quantities[3],
                          'preco': prices[3]
                        },
                      ],
                      frete: shipping,
                      subtotal: subtotal,
                    ),
                  ),
                );
              },
              child: Text("Finalizar"),
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

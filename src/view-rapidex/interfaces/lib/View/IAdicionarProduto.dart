import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/widgets/ImageLabelField.dart';

class AdicionarProdutoScreen extends StatefulWidget {
  const AdicionarProdutoScreen({super.key});

  @override
  _AdicionarProdutoScreenState createState() => _AdicionarProdutoScreenState();
}

class _AdicionarProdutoScreenState extends State<AdicionarProdutoScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  bool restritoPorIdade = false;

  @override
  void dispose() {
    nomeController.dispose();
    validadeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  Future<void> cadastrarProduto() async {
    // Validação básica dos campos
    if (nomeController.text.isEmpty ||
        precoController.text.isEmpty ||
        validadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    // Ação de cadastro do produto (substitua pelo código real de cadastro)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produto cadastrado com sucesso!')),
    );
  }

  // Função para selecionar a validade do produto
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate:
          DateTime.now().add(Duration(days: 365 * 10)), // até 10 anos à frente
    );
    if (pickedDate != null) {
      setState(() {
        validadeController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cadastrar produto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: nomeController,
                    labelText: 'Nome',
                    hintText: 'Inserir nome do produto',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: validadeController,
                    labelText: 'Validade',
                    hintText: 'Inserir validade do produto',
                    onTap: () => _selectDate(context),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: precoController,
                    labelText: 'Preço',
                    hintText: 'Inserir preço do produto',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ImageLabelField(
                    label: 'Imagem',
                    hint: 'Anexar imagem do produto',
                    onAttachPressed: () {
                      // Ação de anexar imagem
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: descricaoController,
                    labelText: 'Descrição',
                    hintText: 'Digite aqui a descrição...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Restrito por idade?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: restritoPorIdade,
                            onChanged: (value) {
                              setState(() {
                                restritoPorIdade = value!;
                              });
                            },
                          ),
                          const Text('Sim'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: restritoPorIdade,
                            onChanged: (value) {
                              setState(() {
                                restritoPorIdade = value!;
                              });
                            },
                          ),
                          const Text('Não'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: cadastrarProduto,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        child: Text(
                          'Cadastrar Produto',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

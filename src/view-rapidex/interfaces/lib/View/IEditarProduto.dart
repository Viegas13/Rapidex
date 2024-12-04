import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/widgets/ImageLabelField.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/View/IHomeFornecedor.dart';
import 'package:interfaces/DTO/Produto.dart';

class EditarProdutoScreen extends StatefulWidget {
  final int id;

  EditarProdutoScreen({super.key, required this.id});

  @override
  _EditarProdutoScreenState createState() => _EditarProdutoScreenState();
}

class _EditarProdutoScreenState extends State<EditarProdutoScreen> {
  late ConexaoDB conexaoDB;
  late ProdutoDAO produtoDAO;
  Uint8List? imagemSelecionada;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  bool restritoPorIdade = false;
  int quantidade = 1;
  TextEditingController quantidadeController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    // Inicializa o objeto ConexaoDB
    conexaoDB = ConexaoDB();
    // Inicia a conexão com o banco de dados
    conexaoDB.initConnection().then((_) {
      produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
      buscarProduto();
    }).catchError((error) {
      print('Erro ao inicializar conexão: $error');
    });
  }

  Future<void> buscarProduto() async {
    try {
      final produto = await produtoDAO.buscarProduto(widget.id);

      if (produto != null) {
        setState(() {
          nomeController.text = produto.nome;

          validadeController.text = produto.validade != null
              ? DateFormat('dd/MM/yyyy').format(produto.validade!)
              : 'Não informado';

          // Converter o telefone de int para String
          precoController.text = produto.preco.toString();

          // emailController.text = cliente.email; imagem
          descricaoController.text = produto.descricao;
          restritoPorIdade = produto.restrito;
          quantidadeController =
              TextEditingController(text: produto.quantidade.toString());
        });
      }
    } catch (e) {
      print('Erro ao buscar cliente: $e');
    }
  }

  Future<void> selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      final Uint8List imageBytes = await imagem.readAsBytes();
      setState(() {
        imagemSelecionada = imageBytes;
      });
    }
  }

  Future<void> salvarAlteracoes() async {
    try {
      final produto = await produtoDAO.buscarProduto(widget.id);

      if (produto != null) {
        double? preco = double.tryParse(precoController.text);
        int? quantidade = int.tryParse(quantidadeController.text);

        if (preco == null || quantidade == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preço ou quantidade inválidos!')),
          );
          return;
        }

        final produtoAtualizado = Produto(
          produto_id: widget.id,
          nome: nomeController.text,
          validade: validadeController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(validadeController.text)
              : null,
          preco: preco,
          imagem: imagemSelecionada,
          descricao: descricaoController.text,
          fornecedorCnpj: '11111111111111',
          restrito: restritoPorIdade,
          quantidade: quantidade,
        );

        await produtoDAO.atualizarProduto(produtoAtualizado.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informações atualizadas com sucesso!')),
        );

        // Passa um valor para a tela anterior para indicar que os dados foram atualizados
        Navigator.pop(context,
            true); // Passando `true` para indicar que as alterações foram feitas
      }
    } catch (e) {
      print('Erro ao salvar alterações: $e');
    }
  }

  // Função para selecionar a validade do produto
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now()
          .add(const Duration(days: 365 * 10)), // até 10 anos à frente
    );
    setState(() {
      validadeController.text = DateFormat('dd/MM/yyyy').format(pickedDate!);
    });
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
          'Editar produto',
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
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: selecionarImagem,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imagemSelecionada != null
                          ? Image.memory(
                              imagemSelecionada!,
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Text(
                                'Anexar imagem do produto',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quantidade',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantidade > 1) {
                                  quantidade--;
                                  quantidadeController.text =
                                      quantidade.toString();
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: quantidadeController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  quantidade = int.tryParse(value) ?? 1;
                                  if (quantidade < 1) quantidade = 1;
                                  quantidadeController.text =
                                      quantidade.toString();
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantidade++;
                                quantidadeController.text =
                                    quantidade.toString();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
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
                      onPressed: salvarAlteracoes,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          'Salvar Alterações',
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

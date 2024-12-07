import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:interfaces/widgets/CustomTextField.dart';
import 'package:interfaces/widgets/ImageLabelField.dart';
import 'package:interfaces/banco_de_dados/DBHelper/ConexaoDB.dart';
import 'package:interfaces/banco_de_dados/DAO/ProdutoDAO.dart';
import 'package:interfaces/View/IHomeFornecedor.dart';
import 'package:interfaces/View/IHomeFornecedor.dart';
import 'package:interfaces/controller/SessionController.dart';
import 'package:interfaces/banco_de_dados/DAO/FornecedorDAO.dart';

class AdicionarProdutoScreen extends StatefulWidget {
  final VoidCallback onProdutoAdicionado;

  const AdicionarProdutoScreen({super.key, required this.onProdutoAdicionado});

  @override
  _AdicionarProdutoScreenState createState() => _AdicionarProdutoScreenState();
}

class _AdicionarProdutoScreenState extends State<AdicionarProdutoScreen> {
  late ConexaoDB conexaoDB;
  late ProdutoDAO produtoDAO;
  Uint8List? imagemSelecionada;
  late FornecedorDAO fornecedorDAO;
  String cnpj = '';
  

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController precoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  bool restritoPorIdade = false;
  int quantidade = 1;
  final TextEditingController quantidadeController = TextEditingController(text: '1');

  SessionController sessionController = SessionController();

  @override
  void initState() {
    super.initState();
    // Inicializa o objeto ConexaoDB
    conexaoDB = ConexaoDB();
    produtoDAO = ProdutoDAO(conexaoDB: conexaoDB);
    fornecedorDAO = FornecedorDAO(conexaoDB: conexaoDB);

    // Inicia a conexão com o banco de dados
    conexaoDB.initConnection().then((_) {
      inicializarDados();

      print('Conexão estabelecida no initState.');
    }).catchError((error) {
      // Se ocorrer um erro ao abrir a conexão, é bom tratar aqui.
      print('Erro ao estabelecer conexão no initState: $error');
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    validadeController.dispose();
    precoController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  Future<void> inicializarDados() async {
  try { 
    cnpj = await fornecedorDAO.buscarCnpj(sessionController.email, sessionController.senha) ?? '';
    if (cnpj.isEmpty) {
      throw Exception('CNPJ não encontrado para o email e senha fornecidos.');
    }
  } catch (e) {
    print('Erro ao inicializar dados: $e');
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

  Future<void> removerImagem() async{
  setState(() {
    imagemSelecionada = null; // Reseta a imagem para null
  });
}

  bool validarCampos() {
  if (nomeController.text.isEmpty) {
    exibirMensagem("O nome do produto é obrigatório!");
    return false;
  }

  if (validadeController.text.isNotEmpty) {
    try {
      DateFormat('dd/MM/yyyy').parse(validadeController.text);
    } catch (_) {
      exibirMensagem("A data de validade não está no formato correto!");
      return false;
    }
  }

  if (precoController.text.isEmpty || double.tryParse(precoController.text) == null) {
    exibirMensagem("O preço informado é inválido!");
    return false;
  }

  if (quantidade <= 0) {
    exibirMensagem("A quantidade deve ser maior que zero!");
    return false;
  }

  return true;
}

void exibirMensagem(String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
}

  Future<bool> cadastrarProduto() async {
    if (!validarCampos()) return false;
    try {
      if (cnpj.isEmpty) {
        throw Exception('CNPJ não foi inicializado.');
      }

      Uint8List? imagemBytes;
      if (imagemSelecionada != null) {
        imagemBytes = imagemSelecionada!;
      }

      Map<String, dynamic> produto = {
        'nome': nomeController.text,
        'validade': validadeController.text,
        'preco': precoController.text,
        'imagem': imagemBytes,
        'descricao': descricaoController.text,
        'fornecedor': cnpj,
        'restrito': restritoPorIdade,
        'quantidade': quantidadeController.text,
      };

      await produtoDAO.cadastrarProduto(produto);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar produto: $e')),
      );
      print('Erro ao cadastrar produto: $e');
      return false;
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
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      if (imagemSelecionada == null) {
                        await selecionarImagem(); // Apenas seleciona imagem se não houver uma
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: imagemSelecionada != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    imagemSelecionada!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'Anexar imagem do produto',
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ),
                        ),
                        if (imagemSelecionada != null)
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                // Remove a imagem
                                removerImagem();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
                                  if (quantidade < 1) {
                                    quantidade = 1;
                                    quantidadeController.text = '1';
                                  }
                                });
                              }
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
                      onPressed: () async {
                        bool sucesso = await cadastrarProduto();
                        if (sucesso) {
                          Navigator.pop(context);
                          widget.onProdutoAdicionado();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
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

import '../DBHelper/ConexaoDB.dart';

class ProdutoDAO {
  final ConexaoDB conexaoDB;

  ProdutoDAO({required this.conexaoDB});

  // Método para cadastrar um produto no banco de dados
  Future<void> cadastrarProduto(Map<String, dynamic> produto) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Realiza a inserção do produto
      await conexaoDB.connection.query(
        '''
        INSERT INTO produto (nome, validade, preco, imagem, descricao, fornecedor, restrito, quantidade)
        VALUES (@nome, @validade, @preco, @imagem, @descricao, @fornecedor, @restrito, @quantidade)
        ''',
        substitutionValues: produto,
      );
      print('Produto cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar produto: $e');
      rethrow; 
    }
  }
}
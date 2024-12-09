import 'package:interfaces/DTO/Produto.dart';
import '../DBHelper/ConexaoDB.dart';

class ProdutoDAO {
  final ConexaoDB conexaoDB;

  ProdutoDAO({required this.conexaoDB});

  Future<void> verificarConexao() async {
    if (conexaoDB.connection.isClosed) {
      print("Conexão fechada. Reabrindo...");
      await conexaoDB.openConnection();
    }
  }

  // Método para cadastrar um produto no banco de dados
  Future<void> cadastrarProduto(Map<String, dynamic> produto) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        INSERT INTO produto (nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade) 
        VALUES (@nome, @validade, @preco, @imagem, @descricao, @fornecedor, @restrito, @quantidade) RETURNING produto_id
        ''',
        substitutionValues: produto,
      );
      print('Produto cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar produto: $e');
      rethrow;
    }
  }

  Future<void> removerProduto(int produto_id) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM produto WHERE produto_id = @produto_id
        ''',
        substitutionValues: {'produto_id': produto_id},
      );
      print('Produto excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir produto: $e');
      rethrow;
    }
  }

  Future<void> atualizarProduto(Map<String, dynamic> produto) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE produto 
        SET nome = @nome, validade = @validade, preco = @preco, imagem = @imagem, descricao = @descricao, fornecedor_cnpj = @fornecedor_cnpj, restritoPorIdade = @restritoPorIdade, quantidade = @quantidade 
        WHERE produto_id = @produto_id
        ''',
        substitutionValues: produto,
      );
      print('Produto atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  Future<void> alterarQuantidade(String nome, int quantidade) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE produto
        SET quantidade = quantidade - @quantidade
        WHERE nome = @nome
        ''',
        substitutionValues: {
          'nome': nome,
          'quantidade': quantidade,
        },
      );

      print('Pedido finalizado');
    } catch (e) {
      print('Erro ao finalizar pedido: $e');
      rethrow;
    }
  }

  Future<List<Produto>> listarTodosProdutos() async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
        SELECT produto_id, nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade
        FROM produto
        WHERE quantidade > 0
        ''',
      );

      return results.map((row) {
        return Produto.fromMap(row.toColumnMap());
      }).toList();
    } catch (e) {
      print('Erro ao listar produtos: $e');
      rethrow;
    }
  }

  Future<List<Produto>> listarProdutosFornecedor(String? cnpjFornecedor) async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
        SELECT produto_id, nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade
        FROM produto WHERE fornecedor_cnpj = @cnpjFornecedor
        ''',
        substitutionValues: {'cnpjFornecedor': cnpjFornecedor},
      );

      return results.map((row) {
        return Produto.fromMap(row.toColumnMap());
      }).toList();
    } catch (e) {
      print('Erro ao listar produtos: $e');
      rethrow;
    }
  }

  Future<List<Produto>> buscarProdutosPorNome(String chave) async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
  SELECT 
    p.produto_id, p.nome, validade, preco, imagem, descricao, fornecedor_cnpj, 
    restritoPorIdade, quantidade, f.nome AS nome_fornecedor
  FROM produto p 
    JOIN fornecedor f ON f.cnpj = p.fornecedor_cnpj
  WHERE p.nome = @chave OR f.nome = @chave;
  ''',
        substitutionValues: {
          'chave': chave,
        },
      );

      return results.map((row) {
        return Produto.fromMap(row.toColumnMap());
      }).toList();
    } catch (e) {
      print('Erro ao listar produtos: $e');
      rethrow;
    }
  }

  Future<Produto?> buscarProduto(int produto_id) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        'SELECT * FROM produto WHERE produto_id = @produto_id',
        substitutionValues: {'produto_id': produto_id},
      );

      if (result.isNotEmpty) {
        return Produto.fromMap(result[0].toColumnMap());
      } else {
        print(produto_id);
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do cliente: $e');
      return null;
    }
  }
}

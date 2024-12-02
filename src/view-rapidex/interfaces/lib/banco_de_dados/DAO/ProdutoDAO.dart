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

  Future<void> removerProduto(String nome) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM produto WHERE idProduto = @id
        ''',
        substitutionValues: {'nome': nome},
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
        SET nome = @nome, validade = @validade, preco = @preco, imagem = @imagem, descricao = @descricao, fornecedor = @fornecedor, restrito = @restrito, quantidade = @quantidade 
        WHERE id = @id
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

  Future<List<Produto>> listarProdutosFornecedor(String cnpjFornecedor) async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
        SELECT nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade
        FROM produto
        WHERE fornecedor_cnpj = @fornecedor_cnpj
        ''',
        substitutionValues: {
          'fornecedor_cnpj': cnpjFornecedor,
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

  Future<List<Produto>> listarTodosProdutos() async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
        SELECT nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade
        FROM produto
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

  Future<List<Produto>> buscarProdutosPorNome(String chave) async {
    try {
      await verificarConexao();

      final results = await conexaoDB.connection.query(
        '''
        SELECT p.nome, validade, preco, imagem, descricao, fornecedor_cnpj, restritoPorIdade, quantidade, f.nome
        FROM produto p 
          JOIN fornecedor f on f.cnpj = p.fornecedor_cnpj
            WHERE nome = @chave OR f.nome = @chave;
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
}

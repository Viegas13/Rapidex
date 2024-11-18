import 'package:interfaces/DTO/Produto.dart';
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
        INSERT INTO produto (nome, validade, preco, imagem, descricao, fornecedor_cnpj, restrito, quantidade)
        VALUES (@nome, @validade, @preco, @imagem, @descricao, @fornecedor, @restritoPorIdade, @quantidade)
        ''',
        substitutionValues: produto,
      );
      print('Produto cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar produto: $e');
      rethrow; 
    }
  }

  Future<void> deletarProduto(int idProduto) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM produto WHERE idProduto = @id
        ''',
        substitutionValues: {'id': idProduto},
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
    // Verifica e abre a conexão, se necessário
    if (conexaoDB.connection.isClosed) {
      await conexaoDB.openConnection();
    }

    // Atualiza a quantidade do produto subtraindo o valor informado
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

Future<Produto?> buscarCliente(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        'SELECT * FROM cliente WHERE cpf = @cpf',
        substitutionValues: {'cpf': cpf},
      );

      if (result.isNotEmpty) {
        return Produto.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do cliente: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> listarProdutos(String cnpjFornecedor) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Consulta os endereços associados ao CPF do cliente
      final results = await conexaoDB.connection.query(
        '''
      SELECT nome, quantidade
      FROM produto
      WHERE fornecedor_cnpj = @fornecedor_cnpj
      ''',
        substitutionValues: {
          'fornecedor_cnpj': cnpjFornecedor,
        },
      );

      print('Resultados encontrados: $results');

      // Mapeia os resultados para uma lista de mapas
      return results.map((row) {
        return {
          'nome': row[0],
          'quantidade': row[1],
        };
      }).toList();
    } catch (e) {
      print('Erro ao listar produtos: $e');
      rethrow;
    }
  }

}
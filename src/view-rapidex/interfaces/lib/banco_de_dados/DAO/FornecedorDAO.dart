import '../DBHelper/ConexaoDB.dart';

class FornecedorDAO {
  final ConexaoDB conexaoDB;

  FornecedorDAO({required this.conexaoDB});

  // Método para cadastrar um fornecedor no banco de dados
  Future<void> cadastrarFornecedor(Map<String, dynamic> fornecedor) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Realiza a inserção do fornecedor
      await conexaoDB.connection.query(
        '''
        INSERT INTO fornecedor (cnpj, nome, email, senha, telefone)
        VALUES (@cnpj, @nome, @email, @senha, @telefone)
        ''',
        substitutionValues: fornecedor,
      );
      print('Fornecedor cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar fornecedor: $e');
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> buscarFornecedor(String cnpj) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      print("abriu conexão");

      var result = await conexaoDB.connection.query(
        'SELECT * FROM fornecedor WHERE cnpj = @cnpj',
        substitutionValues: {'cnpj': cnpj},
      );

      print("fez query");

      return result.isNotEmpty ? result[0].toColumnMap() : null;
    } catch (e) {
      print('Erro ao buscar fornecedor: $e');
      return null;
    }
  }

  // Atualizar fornecedor
  Future<void> atualizarFornecedor(Map<String, dynamic> fornecedor) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE fornecedor
        SET nome = @nome, email = @email, telefone = @telefone, senha = @senha
        WHERE cnpj = @cnpj
        ''',
        substitutionValues: fornecedor,
      );
      print('Fornecedor atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar fornecedor: $e');
      rethrow;
    }
  }

  // Deletar fornecedor
  Future<void> deletarFornecedor(String cnpj) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        'DELETE FROM fornecedor WHERE cnpj = @cnpj',
        substitutionValues: {'cnpj': cnpj},
      );
      print('Fornecedor excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir fornecedor: $e');
      rethrow;
    }
  }

}

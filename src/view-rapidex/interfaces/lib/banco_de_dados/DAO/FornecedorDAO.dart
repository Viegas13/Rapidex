import '../DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Fornecedor.dart';

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
      rethrow; // Aqui rethrow está corretamente dentro do catch
    }
  }

  // Buscar fornecedor para login
  Future<Fornecedor?> BuscarFornecedorParaLogin(
      String email, String senha) async {
    try {
      var result = await conexaoDB.connection.query(
        'SELECT * FROM fornecedor WHERE email = @email AND senha = @senha',
        substitutionValues: {'email': email, 'senha': senha},
      );

      if (result.isNotEmpty) {
        return Fornecedor.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro na busca: $e');
      rethrow; // Aqui rethrow está dentro do catch
    }
  }

  Future<String?> buscarCnpj(String? email, String? senha) async {
  try {
    if (conexaoDB.connection.isClosed) {
      await conexaoDB.openConnection();
    }
    var resultado = await conexaoDB.connection.query(
      'SELECT CNPJ FROM fornecedor WHERE email = @email AND senha = @senha',
      substitutionValues: {'email': email, 'senha': senha},
    );

    if (resultado.isNotEmpty) {
        return resultado.toString().replaceAll(RegExp(r'[\[\]\s]'), '');
      } else {
        return null; // Caso não haja resultados
      }
    } catch (e) {
      print('Erro ao buscar cnpj: $e');
      return null; 
    }
}

  // Buscar fornecedor por CNPJ
  Future<Map<String, dynamic>?> buscarFornecedor(String? cnpj) async {
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
      return null; // Não há rethrow necessário aqui, pois não estamos lidando com a propagação do erro
    }
  }

  // Buscar fornecedor por CNPJ
  Future<String?> buscarNomeFornecedor(String cnpj) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      print("abriu conexão");

      var resultado = await conexaoDB.connection.query(
        'SELECT nome FROM fornecedor WHERE cnpj = @cnpj',
        substitutionValues: {'cnpj': cnpj},
      );

      print("fez query");

      if (resultado.isNotEmpty) {
        return resultado.toString().replaceAll(RegExp(r'[\[\]\s]'), '');
      } else {
        return null; // Caso não haja resultados
      }
    } catch (e) {
      print('Erro ao buscar fornecedor: $e');
      return null; // Não há rethrow necessário aqui, pois não estamos lidando com a propagação do erro
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
      rethrow; // rethrow dentro de catch, adequado
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
      rethrow; // rethrow dentro de catch, adequado
    }
  }
}

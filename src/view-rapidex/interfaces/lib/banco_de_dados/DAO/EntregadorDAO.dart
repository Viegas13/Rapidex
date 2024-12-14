import 'package:interfaces/DTO/Entregador.dart';
import '../DBHelper/ConexaoDB.dart';

class EntregadorDAO {
  final ConexaoDB conexaoDB;

  EntregadorDAO({required this.conexaoDB});

  // Método para cadastrar um Entregador
  Future<void> cadastrarEntregador(Map<String, dynamic> Entregador) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        INSERT INTO Entregador (cpf, nome, senha, email, telefone, datanascimento)
        VALUES (@cpf, @nome, @senha, @email, @telefone, @datanascimento)
        ''',
        substitutionValues: Entregador,
      );
      print('Entregador cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar Entregador: $e');
      rethrow;
    }
  }

  // Método para buscar Entregador pelo CPF e retornar um objeto Entregador
  Future<Entregador?> buscarEntregador(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        'SELECT * FROM Entregador WHERE cpf = @cpf',
        substitutionValues: {'cpf': cpf},
      );

      if (result.isNotEmpty) {
        return Entregador.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do Entregador: $e');
      return null;
    }
  }

  // Método para deletar Entregador
  Future<void> deletarEntregador(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM Entregador WHERE cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );
      print('Entregador excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir Entregador: $e');
      rethrow;
    }
  }

  Future<void> atualizarEntregador(Map<String, dynamic> Entregador) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE Entregador 
        SET nome = @nome, datanascimento = @datanascimento, telefone = @telefone, email = @email 
        WHERE cpf = @cpf
        ''',
        substitutionValues: Entregador,
      );
      print('Entregador atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar Entregador: $e');
      rethrow;
    }
  }

  Future<Entregador?> buscarEntregadorParaLogin(
      String email, String senha) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        'SELECT * FROM Entregador WHERE email = @email AND senha = @senha',
        substitutionValues: {'email': email, 'senha': senha},
      );

      if (result.isNotEmpty) {
        return Entregador.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro na busca: $e');
      rethrow;
    }
  }

  Future<String?> buscarCpf(String? email, String? senha) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var resultado = await conexaoDB.connection.query(
        'SELECT cpf FROM entregador WHERE email = @email AND senha = @senha',
        substitutionValues: {'email': email, 'senha': senha},
      );

      if (resultado.isNotEmpty) {
        return resultado.toString().replaceAll(RegExp(r'[\[\]\s]'), '');
      } else {
        return null; // Caso não haja resultados
      }
    } catch (e) {
      print('Erro ao buscar cpf: $e');
      return null;
    }
  }
}

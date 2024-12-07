import 'package:interfaces/DTO/Cartao.dart';
import '../DBHelper/ConexaoDB.dart';

class CartaoDAO {
  final ConexaoDB conexaoDB;

  CartaoDAO({required this.conexaoDB});

  // Método para cadastrar um cartão
  Future<void> cadastrarCartao(Cartao cartao) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        INSERT INTO cartao (numero, cvv, validade, nomeTitular, agencia, bandeira, cpf_titular, cliente_cpf)
        VALUES (@numero, @cvv, @validade, @nomeTitular, @agencia, @bandeira, @cpf_titular, @cliente_cpf)
        ''',
        substitutionValues: cartao.toMap(),
      );
      print('Cartão cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar cartão: $e');
      rethrow;
    }
  }

  // Método para buscar cartões pelo CPF do cliente
  Future<List<Cartao>> buscarCartoesPorCliente(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        '''
        SELECT numero, cvv, validade, nomeTitular, agencia, bandeira, cpf_titular, cliente_cpf
        FROM cartao
        WHERE cliente_cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );

      return result.map((row) {
        return Cartao.fromMap(row.toColumnMap());
      }).toList();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
      return [];
    }
  }

  // Método para deletar um cartão pelo número
  Future<void> deletarCartao(int numero) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        DELETE FROM cartao WHERE numero = @numero
        ''',
        substitutionValues: {'numero': numero},
      );
      print('Cartão excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir cartão: $e');
      rethrow;
    }
  }

  // Método para atualizar um cartão
  Future<void> atualizarCartao(Cartao cartao) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        UPDATE cartao 
        SET cvv = @cvv, validade = @validade, nomeTitular = @nomeTitular, 
            agencia = @agencia, bandeira = @bandeira, cliente_cpf = @cliente_cpf
        WHERE numero = @numero
        ''',
        substitutionValues: cartao.toMap(),
      );
      print('Cartão atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar cartão: $e');
      rethrow;
    }
  }

  // Método para buscar um cartão específico pelo número
  Future<Cartao?> buscarCartaoPorNumero(int numero) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        '''
        SELECT numero, cvv, validade, nomeTitular, agencia, bandeira, cliente_cpf
        FROM cartao
        WHERE numero = @numero
        ''',
        substitutionValues: {'numero': numero},
      );

      if (result.isNotEmpty) {
        return Cartao.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar cartão: $e');
      return null;
    }
  }
}

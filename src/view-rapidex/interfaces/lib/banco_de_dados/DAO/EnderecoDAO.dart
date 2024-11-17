import '../DBHelper/ConexaoDB.dart';

class EnderecoDAO {
  final ConexaoDB conexaoDB;

  EnderecoDAO({required this.conexaoDB});

  // Método para cadastrar um Endereco no banco de dados
  Future<void> cadastrarEndereco(Map<String, dynamic> Endereco) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Realiza a inserção do Endereco
      await conexaoDB.connection.query(
        '''
        INSERT INTO Endereco (bairro, rua, numero, cep, complemento, referencia)
        VALUES (@bairro, @rua, @numero, @cep, @complemento, @referencia)
        ''',
        substitutionValues: Endereco,
      );
      print('Endereco cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar Endereco: $e');
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> listarEnderecos(String clienteCpf) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Consulta os endereços associados ao CPF do cliente
      final results = await conexaoDB.connection.query(
        '''
      SELECT rua, numero, bairro, cep, complemento, referencia
      FROM Endereco
      WHERE cliente_cpf = @cliente_cpf
      ''',
        substitutionValues: {
          'cliente_cpf': clienteCpf,
        },
      );

      print('Resultados encontrados: $results');

      // Mapeia os resultados para uma lista de mapas
      return results.map((row) {
        return {
          'rua': row[0],
          'numero': row[1],
          'bairro': row[2],
          'cep': row[3],
          'complemento': row[4],
          'referencia': row[5],
        };
      }).toList();
    } catch (e) {
      print('Erro ao listar endereços: $e');
      rethrow;
    }
  }

  Future<void> deletarEndereco(String clienteCpf, String cep) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      final int rowsAffected = await conexaoDB.connection.execute(
        '''
        DELETE FROM Endereco 
        WHERE cliente_cpf = @cliente_cpf AND cep = @cep
        ''',
        substitutionValues: {
          'cliente_cpf': clienteCpf,
          'cep': cep,
        },
      );

      if (rowsAffected > 0) {
        print('Endereço deletado com sucesso!');
      } else {
        print('Nenhum endereço encontrado para deletar.');
      }
    } catch (e) {
      print('Erro ao deletar Endereço: $e');
      rethrow;
    }
  }

}

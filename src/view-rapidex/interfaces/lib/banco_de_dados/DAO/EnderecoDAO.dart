import '../DBHelper/ConexaoDB.dart';

class EnderecoDAO {
  final ConexaoDB conexaoDB;

  EnderecoDAO({required this.conexaoDB});

  // Método para cadastrar um Endereco no banco de dados
  Future<void> cadastrarEndereco(Map<String, dynamic> endereco) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Gera o endereco_id com base no cliente_cpf e cep
      final String enderecoId = '${endereco['cep']}_${endereco['cliente_cpf']}';

      // Realiza a inserção do Endereco
      await conexaoDB.connection.query(
        '''
        INSERT INTO Endereco (endereco_id, cliente_cpf, bairro, rua, numero, cep, complemento, referencia)
        VALUES (@endereco_id, @cliente_cpf, @bairro, @rua, @numero, @cep, @complemento, @referencia)
        ''',
        substitutionValues: {
          'endereco_id': enderecoId,
          ...endereco,
        },
      );
      print('Endereco cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar Endereco: $e');
      rethrow;
    }
  }

  // Método para listar endereços de um cliente específico
  Future<List<Map<String, dynamic>>> listarEnderecos(String clienteCpf) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Consulta os endereços associados ao CPF do cliente
      final results = await conexaoDB.connection.query(
        '''
      SELECT endereco_id, rua, numero, bairro, cep, complemento, referencia
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
          'endereco_id': row[0],
          'rua': row[1],
          'numero': row[2],
          'bairro': row[3],
          'cep': row[4],
          'complemento': row[5],
          'referencia': row[6],
        };
      }).toList();
    } catch (e) {
      print('Erro ao listar endereços: $e');
      rethrow;
    }
  }

  // Método para deletar um endereço com base no endereco_id
  Future<void> deletarEndereco(String clienteCpf, String cep) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Gera o endereco_id com base no cliente_cpf e cep
      final String enderecoId = '${cep}_$clienteCpf';

      final int rowsAffected = await conexaoDB.connection.execute(
        '''
        DELETE FROM Endereco 
        WHERE endereco_id = @endereco_id
        ''',
        substitutionValues: {
          'endereco_id': enderecoId,
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

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

      // Realiza a inserção do Endereco
      await conexaoDB.connection.query(
        '''
        INSERT INTO Endereco (cliente_cpf, bairro, rua, numero, cep, complemento, referencia)
        VALUES (@cliente_cpf, @bairro, @rua, @numero, @cep, @complemento, @referencia)
        ''',
        substitutionValues: {
          ...endereco,
        },
      );
      print('Endereco cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar Endereco: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> listarEnderecos() async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Executa a consulta para listar os endereços
      final List<Map<String, Map<String, dynamic>>> results =
          await conexaoDB.connection.mappedResultsQuery('''
        SELECT cliente_cpf, bairro, rua, numero, cep, complemento, referencia 
        FROM Endereco
        ''');

      // Transforma os resultados em uma lista de mapas simples
      return results.map((row) => row['endereco'] ?? {}).toList();
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

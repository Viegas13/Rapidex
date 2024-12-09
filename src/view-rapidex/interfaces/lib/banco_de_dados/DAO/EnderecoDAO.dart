import '../DBHelper/ConexaoDB.dart';

class EnderecoDAO {
  final ConexaoDB conexaoDB;

  EnderecoDAO({required this.conexaoDB});

  Future<void> cadastrarEnderecoCliente(Map<String, dynamic> endereco) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      final String enderecoId = '${endereco['cep']}_${endereco['cliente_cpf']}';

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

  Future<void> cadastrarEnderecoFornecedor(Map<String, dynamic> endereco) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      final String enderecoId = '${endereco['cep']}_${endereco['fornecedor_cnpj']}';

      await conexaoDB.connection.query(
        '''
        INSERT INTO Endereco (endereco_id, fornecedor_cnpj, bairro, rua, numero, cep, complemento, referencia)
        VALUES (@endereco_id, @fornecedor_cnpj, @bairro, @rua, @numero, @cep, @complemento, @referencia)
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

  Future<List<Map<String, dynamic>>> listarEnderecosCliente(String clienteCpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

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

  Future<List<Map<String, dynamic>>> listarEnderecosFornecedor(String fornecedorCnpj) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      final results = await conexaoDB.connection.query(
        '''
      SELECT endereco_id, rua, numero, bairro, cep, complemento, referencia
      FROM Endereco
      WHERE fornecedor_cnpj = @fornecedor_cnpj
      ''',
        substitutionValues: {
          'fornecedor_cnpj': fornecedorCnpj,
        },
      );

      print('Resultados encontrados: $results');

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

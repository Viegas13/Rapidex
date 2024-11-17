import '../DBHelper/ConexaoDB.dart';

class CartaoDAO {
  final ConexaoDB conexaoDB;

  CartaoDAO({required this.conexaoDB});

  // Método para cadastrar um novo cartão no banco de dados
  Future<void> cadastrarCartao(Map<String, dynamic> cartao) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        INSERT INTO Cartao (numero, cvv, validade, nomeTitular, agencia, bandeira, cliente_cpf)
        VALUES (@numero, @cvv, @validade, @nomeTitular, @agencia, @bandeira, @cliente_cpf)
        ''',
        substitutionValues: cartao,
      );
      print('Cartão cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar cartão: $e');
      rethrow;
    }
  }

  // Método para buscar cartões por CPF do cliente
  Future<List<Map<String, dynamic>>> buscarCartoesPorCliente(String cpf) async {
       try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
        SELECT numero, nomeTitular, bandeira, validade
        FROM Cartao
        WHERE cliente_cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );

      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
      return [];
    }
  }
}

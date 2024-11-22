import 'package:interfaces/DTO/Cartao.dart';
import '../DBHelper/ConexaoDB.dart';

class CartaoDAO {
  final ConexaoDB conexaoDB;

  CartaoDAO({required this.conexaoDB});

  // Método para cadastrar um cartão no banco de dados
  Future<void> cadastrarCartao(Cartao cartao) async {
    try {
      await conexaoDB.openConnection(); // Garante que a conexão está aberta
      var connection = conexaoDB.connection;
      await connection.query(
        '''
        INSERT INTO Cartao (numero, cvv, validade, nomeTitular, agencia, bandeira, cliente_cpf)
        VALUES (@numero, @cvv, @validade, @nomeTitular, @agencia, @bandeira, @cliente_cpf)
        ''',
        substitutionValues: cartao.toMap(),
      );
      print('Cartão cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar cartão: $e');
      rethrow;
    }
  }

  // Método para buscar cartões de um cliente pelo CPF
  Future<List<Cartao>> buscarCartoesPorCliente(String cpf) async {
    try {
      await conexaoDB.openConnection(); // Garante que a conexão está aberta
      var connection = conexaoDB.connection;
      var result = await connection.query(
        '''
        SELECT numero, nomeTitular, bandeira, validade
        FROM Cartao
        WHERE cliente_cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );

      return result.map((row) {
        return Cartao(
          numero: row[0],
          nomeTitular: row[1],
          bandeira: row[2],
          cpfCliente: cpf,
          validade: row[3],
          codigoSeguranca: '', // Adapte conforme necessário
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
      return [];
    }
  }
}

import 'package:interfaces/DTO/Cartao.dart';
import '../DBHelper/ConexaoDB.dart';

class CartaoDAO {
  final ConexaoDB conexaoDB;

  CartaoDAO({required this.conexaoDB});

  // Método para cadastrar um novo cartão no banco de dados
  Future<void> cadastrarCartao(Cartao cartao) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
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

  // Método para buscar cartões por CPF do cliente
  Future<List<Cartao>> buscarCartoesPorCliente(String cpf) async {
       try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
        SELECT numero, nomeTitular, bandeira, validade
        FROM Cartao
        WHERE cliente_cpf = a@cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );

      return result.map((row) {
        return Cartao(
          numero: row[0],
          nomeTitular: row[1],
          bandeira: row[2],
          cpfCliente: row[3],
          validade: row[4],
          codigoSeguranca: row[5],
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar cartões: $e');
      return [];
    }
  }
}

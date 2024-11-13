
import '../DBHelper/ConexaoDB.dart';

class ClienteDAO {
  final ConexaoDB conexaoDB;

  ClienteDAO({required this.conexaoDB});

  // Método para cadastrar um cliente no banco de dados
  Future<void> cadastrarCliente(Map<String, dynamic> cliente) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Realiza a inserção do cliente
      await conexaoDB.connection.query(
        '''
        INSERT INTO clientes (cpf, nome, senha, email, telefone, datanascimento)
        VALUES (@cpf, @nome, @senha, @email, @telefone, @datanascimento)
        ''',
        substitutionValues: cliente,
      );
      print('Cliente cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar cliente: $e');
      rethrow; 
    }
  }
}
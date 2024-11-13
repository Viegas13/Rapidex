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
}

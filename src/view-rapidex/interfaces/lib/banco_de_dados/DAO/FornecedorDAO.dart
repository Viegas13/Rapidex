import '../DBHelper/ConexaoDB.dart';

class FornecedorDAO {
  final ConexaoDB conexaoDB;

  FornecedorDAO({required this.conexaoDB});

  // Método para cadastrar um fornecedor no banco de dados
  Future<void> cadastrarFornecedor(Map<String, dynamic> fornecedor) async {
    try {
      // Garante que a conexão está aberta
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      // Realiza a inserção do fornecedor
      await conexaoDB.connection.query(
        '''
        INSERT INTO fornecedor (cnpj, nome, email, senha, telefone)
        VALUES (@cnpj, @nome, @email, @senha, @telefone)
        ''',
        substitutionValues: fornecedor,
      );
      print('Fornecedor cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar fornecedor: $e');
      rethrow;
    }
  }
}

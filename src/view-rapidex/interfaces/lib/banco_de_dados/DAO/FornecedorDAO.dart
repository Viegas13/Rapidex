import '../DBHelper/ConexaoDB.dart';
import 'package:interfaces/DTO/Fornecedor.dart';

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

  Future<Fornecedor?> BuscarFornecedorParaLogin(String email, String senha) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        'SELECT * FROM fornecedor WHERE email = @email AND senha = @senha',
        substitutionValues: {'email': email.toString(), 'senha': senha.toString()},
      );
      
      if (result.isNotEmpty) {
        return Fornecedor.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro na busca: $e');
      rethrow;
    }
  }
}

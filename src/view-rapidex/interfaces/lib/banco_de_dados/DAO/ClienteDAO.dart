import 'package:interfaces/DTO/Cliente.dart';
import '../DBHelper/ConexaoDB.dart';

class ClienteDAO {
  final ConexaoDB conexaoDB;

  ClienteDAO({required this.conexaoDB});

  // Método para cadastrar um cliente
  Future<void> cadastrarCliente(Map<String, dynamic> cliente) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        INSERT INTO cliente (cpf, nome, senha, email, telefone, datanascimento)
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

  // Método para buscar cliente pelo CPF e retornar um objeto Cliente
  Future<Cliente?> buscarCliente(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        'SELECT * FROM cliente WHERE cpf = @cpf',
        substitutionValues: {'cpf': cpf},
      );

      if (result.isNotEmpty) {
        return Cliente.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do cliente: $e');
      return null;
    }
  }

  // Método para deletar cliente
  Future<void> deletarCliente(String cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM cliente WHERE cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf},
      );
      print('Cliente excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir cliente: $e');
      rethrow;
    }
  }

  Future<void> atualizarCliente(Map<String, dynamic> cliente) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE cliente 
        SET nome = @nome, datanascimento = @datanascimento, telefone = @telefone, email = @email 
        WHERE cpf = @cpf
        ''',
        substitutionValues: cliente,
      );
      print('Cliente atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar cliente: $e');
      rethrow;
    }
  }

  Future<Cliente?> BuscarClienteParaLogin(String email, String senha) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        'SELECT * FROM cliente WHERE email = @email AND senha = @senha',
        substitutionValues: {'email': email, 'senha': senha},
      );

      if (result.isNotEmpty) {
        return Cliente.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro na busca: $e');
      rethrow;
    }
  }
}

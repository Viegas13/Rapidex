import 'package:postgres/postgres.dart';

class ConexaoDB {
  final PostgreSQLConnection connection;

  ConexaoDB({required this.connection});

  // Método para abrir a conexão com o banco de dados
  Future<void> openConnection() async {
    try {
      await connection.open();
      print('Conexão com o banco de dados aberta.');
    } catch (e) {
      print('Erro ao abrir a conexão: $e');
      throw e; // Lançando erro para ser tratado na camada superior
    }
  }

  // Método para fechar a conexão com o banco de dados
  Future<void> closeConnection() async {
    try {
      await connection.close();
      print('Conexão com o banco de dados fechada.');
    } catch (e) {
      print('Erro ao fechar a conexão: $e');
      throw e; // Lançando erro para ser tratado na camada superior
    }
  }
}
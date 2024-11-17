import 'package:postgres/postgres.dart';

class ConexaoDB {
  late PostgreSQLConnection connection;

  ConexaoDB(); // Construtor sem parâmetros

  // Método para inicializar a conexão
  Future<void> initConnection() async {
    // Defina a conexão com o banco de dados
    connection = PostgreSQLConnection(
      '10.0.2.2', // Usando 10.0.2.2 para acessar o localhost em emuladores Android
      5432, // Porta do PostgreSQL
      'Rapidex', // Nome do banco de dados
      username: 'postgres', // Nome de usuário do PostgreSQL
      password: 'admin', // Senha do banco de dados
    );
    await openConnection();
  }

  // Método para abrir a conexão com o banco de dados
  Future<void> openConnection() async {
    try {
      await connection.open();
      print('Conexão com o banco de dados aberta.');
    } catch (e) {
      print('Erro ao abrir a conexão: $e');
      rethrow;
    }
  }

  // Método para fechar a conexão com o banco de dados
  Future<void> closeConnection() async {
    try {
      await connection.close();
      print('Conexão com o banco de dados fechada.');
    } catch (e) {
      print('Erro ao fechar a conexão: $e');
      rethrow;
    }
  }
}
import '../DBHelper/ConexaoDB.dart';
import '../../DTO/Pedido.dart';

class PedidoDAO {
  final ConexaoDB conexaoDB;

  PedidoDAO({required this.conexaoDB});

  // Método para cadastrar um pedido no banco de dados
  Future<void> cadastrarPedido(Pedido pedido) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        INSERT INTO Pedido (cliente_cpf, fornecedor_cnpj, endereco_entrega, preco, frete, status_pedido)
        VALUES (@cliente_cpf, @fornecedor_cnpj, @endereco_entrega, @preco, @frete, @status_pedido)
        ''',
        substitutionValues: pedido.toMap(),
      );
      print('Pedido cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar pedido: $e');
      rethrow;
    }
  }
  
  Future<List<Pedido>> buscarPedidosPorStatus({
  required String cliente_cpf,
  required List<String> status_pedido,
  }) async {
    try {
      // Constrói a consulta para buscar os pedidos
      final result = await conexaoDB.connection.query(
        '''
        SELECT * FROM Pedido 
        WHERE cliente_cpf = @cliente_cpf AND status_pedido = ANY(@status_pedido)
        ''',
        substitutionValues: {
          'cliente_cpf': cliente_cpf,
          'status_pedido': status_pedido,
        },
      );

      // Mapeia os resultados em objetos Pedido
      return result.map((row) => Pedido.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro ao buscar pedidos por status: $e');
      return [];
    }
  }

  // Método para verificar se há pedidos pendentes ou a caminho
  Future<bool> verificarPedidoAtivo(String cliente_cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
        SELECT COUNT(*) 
        FROM Pedido 
        WHERE cliente_cpf = @cliente_cpf AND status_pedido IN ('pendente', 'em preparo', 'pronto', 'retirado',)
        ''',
        substitutionValues: {'cliente_cpf': cliente_cpf},
      );

      return result.first[0] > 0;
    } catch (e) {
      print('Erro ao verificar pedidos ativos: $e');
      rethrow;
    }
  }

  // Método para atualizar o status de um pedido
  Future<void> atualizarStatusPedido(int pedidoId, String novoStatus) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE Pedido 
        SET status_pedido = @novoStatus 
        WHERE pedido_id = @pedidoId
        ''',
        substitutionValues: {'novoStatus': novoStatus, 'pedidoId': pedidoId},
      );
      print('Status do pedido atualizado para $novoStatus!');
    } catch (e) {
      print('Erro ao atualizar status do pedido: $e');
      rethrow;
    }
  }

  // Método para buscar pedidos por cliente
  Future<List<Pedido>> buscarPedidosPorCliente(String cliente_cpf) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
        SELECT * 
        FROM Pedido 
        WHERE cliente_cpf = @cliente_cpf
        ''',
        substitutionValues: {'cliente_cpf': cliente_cpf},
      );

      return result.map((row) {
        return Pedido.fromMap({
          'pedido_id': row[0],
          'cliente_cpf': row[1],
          'fornecedor_cnpj': row[2],
          'endereco_entrega': row[3],
          'preco': row[4],
          'status_pedido': row[5],
        });
      }).toList();
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
      rethrow;
    }
  }

  Future<List<Pedido>> buscarPedidosDisponiveisEntrega() async {
    try {
      // Constrói a consulta para buscar os pedidos
      final result = await conexaoDB.connection.query(
        '''
        SELECT * FROM Pedido 
        WHERE status_pedido = 'em preparo'
        ''',
      );

      return result.map((row) => Pedido.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro ao buscar pedidos por status: $e');
      return [];
    }
  }
}

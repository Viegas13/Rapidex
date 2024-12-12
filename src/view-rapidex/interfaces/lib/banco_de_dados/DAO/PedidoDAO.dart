import '../DBHelper/ConexaoDB.dart';
import '../../DTO/Pedido.dart';
import '../../DTO/ItemPedido.dart';

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
        INSERT INTO Pedido (cliente_cpf, fornecedor_cnpj, preco, frete, data_de_entrega, endereco_entrega, status_pedido )
        VALUES (@cliente_cpf, @fornecedor_cnpj, @preco, @frete, @data_de_entrega, @endereco_entrega, @status_pedido )
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
        WHERE cliente_cpf = @cliente_cpf AND status_pedido IN ('pendente', 'em preparo', 'pronto', 'retirado')
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
  Future<void> atualizarStatusPedido(int? pedidoId, String novoStatus) async {
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

  Future<Pedido?> buscarPedidoPorId(int pedidoId) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
      SELECT * 
      FROM Pedido 
      WHERE pedido_id = @pedido_id
      ''',
        substitutionValues: {'pedido_id': pedidoId},
      );

      if (result.isNotEmpty) {
        return Pedido.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do pedido: $e');
      return null;
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
        ORDER BY pedido_id ASC
        ''',
        substitutionValues: {'cliente_cpf': cliente_cpf},
      );

      return result.map((row) {
        return Pedido.fromMap({
          'pedido_id': row[0],
          'cliente_cpf': row[1],
          'fornecedor_cnpj': row[2],
          'preco': row[3],
          'frete': row[4],
          'data_de_entrega': row[5],
          'endereco_entrega': row[6],
          'status_pedido': row[7],
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
        WHERE status_pedido in ('em preparo', 'pronto')
        ''',
      );

      return result.map((row) => Pedido.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro ao buscar pedidos por status: $e');
      return [];
    }
  }

  Future<List<Pedido>> buscarPedidosPorFornecedor(
      String fornecedor_cnpj) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      var result = await conexaoDB.connection.query(
        '''
        SELECT * 
        FROM Pedido 
        WHERE fornecedor_cnpj = @fornecedor_cnpj
        ''',
        substitutionValues: {'fornecedor_cnpj': fornecedor_cnpj},
      );

      return result.map((row) {
        return Pedido.fromMap({
          'pedido_id': row[0],
          'cliente_cpf': row[1],
          'fornecedor_cnpj': row[2],
          'preco': row[3],
          'frete': row[4],
          'data_de_entrega': row[5],
          'endereco_entrega': row[6],
          'status_pedido': row[7],
        });
      }).toList();
    } catch (e) {
      print('Erro ao buscar pedidos: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscarItensPorPedido(int? pedidoId) async {
    final connection = conexaoDB.connection;

    final List<List<dynamic>> results = await connection.query(
      '''
      SELECT ip.produto_id, p.nome, ip.quantidade, ip.valor_total
      FROM Item_Pedido ip
      JOIN Produto p ON ip.produto_id = p.produto_id
      WHERE ip.pedido_id = @pedidoId
      ''',
      substitutionValues: {'pedidoId': pedidoId},
    );

    if (results.isEmpty) {
      print('Nenhum resultado encontrado para pedido_id: $pedidoId');
    }

    return results.map((row) {
      return {
        'produto_id': row[0],
        'nome_produto': row[1],
        'quantidade': row[2],
        'valor_total': row[3],
      };
    }).toList();
  }
}

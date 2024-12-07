import 'package:interfaces/DTO/ItemPedido.dart';
import '../DBHelper/ConexaoDB.dart';

class ItemPedidoDAO {
  final ConexaoDB conexaoDB;

  ItemPedidoDAO({required this.conexaoDB});

  Future<void> verificarConexao() async {
    if (conexaoDB.connection.isClosed) {
      print("Conexão fechada. Reabrindo...");
      await conexaoDB.openConnection();
    }
  }

  /// Método para cadastrar um ItemPedido
  Future<void> cadastrarItemPedido(Map<String, dynamic> itemPedido) async {
    try {
      await verificarConexao();
      await conexaoDB.connection.query(
        '''
        INSERT INTO Item_Pedido (produto_id, pedido_id, quantidade, valor_total, cliente_cpf)
        VALUES (@produto_id, @pedido_id, @quantidade, @valor_total, @cliente_cpf)
        RETURNING item_pedido_id
        ''',
        substitutionValues: itemPedido,
      );
      print('ItemPedido cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar ItemPedido: $e');
      rethrow;
    }
  }

  /// Método para listar todos os itens de pedidos
  Future<List<ItemPedido>> listarItensPedido() async {
    try {
      await verificarConexao();
      final results = await conexaoDB.connection.query(
        '''
        SELECT item_pedido_id, produto_id, pedido_id, quantidade, valor_total, cliente_cpf
        FROM Item_Pedido
        ''',
      );

      return results.map((row) => ItemPedido.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro ao listar itens de pedidos: $e');
      rethrow;
    }
  }

  /// Método para buscar itens de um pedido específico
  Future<List<ItemPedido>> buscarItensPorPedido(int pedidoId) async {
    try {
      await verificarConexao();
      final results = await conexaoDB.connection.query(
        '''
        SELECT item_pedido_id, produto_id, pedido_id, quantidade, valor_total, cliente_cpf
        FROM Item_Pedido
        WHERE pedido_id = @pedido_id
        ''',
        substitutionValues: {'pedido_id': pedidoId},
      );

      return results.map((row) => ItemPedido.fromMap(row.toColumnMap())).toList();
    } catch (e) {
      print('Erro ao buscar itens do pedido $pedidoId: $e');
      rethrow;
    }
  }

  /// Método para atualizar um ItemPedido
  Future<void> atualizarItemPedido(Map<String, dynamic> itemPedido) async {
    try {
      await verificarConexao();
      await conexaoDB.connection.query(
        '''
        UPDATE Item_Pedido 
        SET produto_id = @produto_id, 
            pedido_id = @pedido_id, 
            quantidade = @quantidade, 
            valor_total = @valor_total, 
            cliente_cpf = @cliente_cpf
        WHERE item_pedido_id = @item_pedido_id
        ''',
        substitutionValues: itemPedido,
      );
      print('ItemPedido atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar ItemPedido: $e');
      rethrow;
    }
  }

  /// Método para remover um ItemPedido
  Future<void> removerItemPedido(int itemPedidoId) async {
    try {
      await verificarConexao();
      await conexaoDB.connection.query(
        '''
        DELETE FROM Item_Pedido WHERE item_pedido_id = @item_pedido_id
        ''',
        substitutionValues: {'item_pedido_id': itemPedidoId},
      );
      print('ItemPedido removido com sucesso!');
    } catch (e) {
      print('Erro ao remover ItemPedido: $e');
      rethrow;
    }
  }
}

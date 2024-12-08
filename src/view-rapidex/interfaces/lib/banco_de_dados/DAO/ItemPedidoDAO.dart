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

Future<void> cadastrarItemPedido(Map<String, dynamic> itemPedido) async {
  try {
    await verificarConexao();

    // Listar todos os itens já cadastrados
    final itensCadastrados = await listarItensPedido();

    // Verificar se o produto_id e pedido_id já existem
    late ItemPedido? itemExistente = null;

     for (var item in itensCadastrados) {
      print("Antes do if");
      print(itemPedido['pedido_id']);
      /*
      Nesse if, comparo se o pedidoId é igual a zero porque é dessa maneira,
      aparentemente, que o map armazena null pra um int
      */
      if (item.produtoId == itemPedido['produto_id'] && item.pedidoId == 0 && item.clienteCpf == itemPedido['cliente_cpf']) {
        print("Passou do if");
        itemExistente = item;
        break;
      }
    }



    if (itemExistente != null) {
      // Atualizar a quantidade do item existente
      final novaQuantidade = itemPedido['quantidade'];
      await atualizarItemPedido({
        'item_pedido_id': itemExistente.itemPedidoId,
        'produto_id': itemExistente.produtoId,
        'pedido_id': null, 
        /*Aqui adiciono null porque isso é o que foi acordado para representar
        que o pedido ainda não foi criado
        */ 
        'quantidade': novaQuantidade,
        'valor_total': novaQuantidade * (itemPedido['valor_total'] / itemPedido['quantidade']),
        'cliente_cpf': itemExistente.clienteCpf,
      });
      print('Quantidade do ItemPedido atualizada com sucesso!');
    } else {
      // Cadastrar um novo itemPedido
      await conexaoDB.connection.query(
        '''
        INSERT INTO Item_Pedido (produto_id, pedido_id, quantidade, valor_total, cliente_cpf)
        VALUES (@produto_id, @pedido_id, @quantidade, @valor_total, @cliente_cpf)
        RETURNING item_pedido_id
        ''',
        substitutionValues: itemPedido,
      );
      print('ItemPedido cadastrado com sucesso!');
    }
  } catch (e) {
    print('Erro ao cadastrar ou atualizar ItemPedido: $e');
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

  //atualiza o ID do item pedido e remove o cliente vinculado a esse item pedido 
  Future<void> atualizarIDItemPedido(int itemPedidoID, int? pedidoid) async {
    try {
      await verificarConexao();
      await conexaoDB.connection.query(
        '''
        UPDATE Item_Pedido 
        SET pedido_id = @pedido_id,
        cliente_cpf = NULL
        WHERE item_pedido_id = @item_pedido_id
        ''',
        substitutionValues: {
          'pedido_id': pedidoid,           // Substitui o @pedido_id
          'item_pedido_id': itemPedidoID   // Substitui o @item_pedido_id
        },
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

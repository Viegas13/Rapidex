import 'package:interfaces/DTO/Entrega.dart';
import 'package:interfaces/DTO/Status.dart';
import '../DBHelper/ConexaoDB.dart';

class EntregaDAO {
  final ConexaoDB conexaoDB;

  EntregaDAO({required this.conexaoDB});

  Future<void> verificarConexao() async {
    if (conexaoDB.connection.isClosed) {
      print("Conexão fechada. Reabrindo...");
      await conexaoDB.openConnection();
    }
  }

  Future<void> cadastrarEntrega(Entrega entrega) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        INSERT INTO entrega (pedido_id, entregador_cpf, status_entrega, endereco_retirada, endereco_entrega, valor_final)
        VALUES (@pedidoId, @entregadorCPF, @status, @enderecoRetirada, @enderecoEntrega, @valorFinal)
        ''',
        substitutionValues: entrega.toMap(),
      );
      print('Entrega cadastrada com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar entrega: $e');
      rethrow;
    }
  }

  Future<void> removerEntrega(int entregaId) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM entrega WHERE entrega_id = @entregaId
        ''',
        substitutionValues: {'entregaId': entregaId},
      );
      print('Entrega excluída com sucesso!');
    } catch (e) {
      print('Erro ao excluir entrega: $e');
      rethrow;
    }
  }

  Future<void> atualizarEntrega(Entrega entrega) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE entrega 
        SET 
          pedido_id = @pedidoId,
          entregador_cpf = @entregadorCPF,
          status_entrega = @status,
          endereco_retirada = @enderecoRetirada,
          endereco_entrega = @enderecoEntrega,
          valor_final = @valorFinal
        WHERE entrega_id = @entregaId
        ''',
        substitutionValues: entrega.toMap(),
      );
      print('Entrega atualizada com sucesso!');
    } catch (e) {
      print('Erro ao atualizar entrega: $e');
      rethrow;
    }
  }

  Future<Entrega?> buscarEntrega(int entregaId) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        '''
        SELECT entrega_id AS entregaId, pedido_id AS pedidoId, entregador_cpf AS entregadorCPF, 
               status_entrega AS status, endereco_retirada AS enderecoRetirada, 
               endereco_entrega AS enderecoEntrega, valor_final AS valorFinal
        FROM entrega
        WHERE entrega_id = @entregaId
        ''',
        substitutionValues: {'entregaId': entregaId},
      );

      if (result.isNotEmpty) {
        return Entrega.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar entrega: $e');
      return null;
    }
  }

  Future<List<Entrega>> buscarEntregasPorEntregadorStatus(String cpf, Status status) async {
  try {
    if (conexaoDB.connection.isClosed) {
      await conexaoDB.openConnection();
    }

    var result = await conexaoDB.connection.query(
      '''
      SELECT * FROM entrega
      WHERE entregador_cpf = @cpf AND status_entrega = @status
      ''',
      substitutionValues: {'cpf': cpf, 'status': status.name},
    );

    if (result.isNotEmpty) {
      return result.map((row) => Entrega.fromMap(row.toColumnMap())).toList();
    } else {
      return [];
    }
  } catch (e) {
    print('Erro ao buscar entregas: $e');
    return [];
  }
}

  Future<Entrega?> buscarEntregaPorEntregadorStatus2(String cpf, List<Status> status) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        '''
        SELECT * FROM entrega
        WHERE entregador_cpf = @cpf AND status_entrega IN (@status1, @status2, @status3)
        ''',
        substitutionValues: {'cpf': cpf, 'status1': status[0].name, 'status2': status[1].name, 'status3': status[2].name},
      );

      if (result.isNotEmpty) {
        return Entrega.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar entrega: $e');
      return null;
    }
  }

  Future<void> atualizarStatusEntrega(String cpf, Status status) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      await conexaoDB.connection.query(
        '''
        UPDATE entrega
        SET status_entrega = @status
        WHERE entregador_cpf = @cpf
        ''',
        substitutionValues: {'cpf': cpf, 'status': status.name},
      );

    } catch (e) {
      print('Erro ao buscar entrega: $e');
      return null;
    }
  }
}

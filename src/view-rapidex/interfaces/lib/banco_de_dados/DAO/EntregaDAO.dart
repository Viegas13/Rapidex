import 'package:interfaces/DTO/Entrega.dart';
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

  Future<void> cadastrarEntrega(Map<String, dynamic> produto) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        INSERT INTO entrega (pedido_id, entregador_cpf, status_entrega, endereco_cliente_cpf, endereco_cep, frete)
        VALUES (@pedido_id, @entregador_cpf, @status_entrega, @endereco_cliente_cpf, @endereco_cep, @frete)
        ''',
        substitutionValues: produto,
      );
      print('Entrega cadastrado com sucesso!');
    } catch (e) {
      print('Erro ao cadastrar entrega: $e');
      rethrow;
    }
  }

  Future<void> removerEntrega(int id) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        DELETE FROM entrega WHERE entrega_id = @id
        ''',
        substitutionValues: {'entrega_id': id},
      );
      print('Entrega excluído com sucesso!');
    } catch (e) {
      print('Erro ao excluir entrega: $e');
      rethrow;
    }
  }

  Future<void> atualizarProduto(Map<String, dynamic> produto) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }

      await conexaoDB.connection.query(
        '''
        UPDATE produto 
        SET status_entrega = @status_entrega,
        WHERE id = @id
        ''',
        substitutionValues: produto,
      );
      print('Produto atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  Future<Entrega?> buscarEntrega(int id) async {
    try {
      if (conexaoDB.connection.isClosed) {
        await conexaoDB.openConnection();
      }
      var result = await conexaoDB.connection.query(
        'SELECT * FROM entrega WHERE entrega_id = @id',
        substitutionValues: {'entrega_id': id},
      );

      if (result.isNotEmpty) {
        return Entrega.fromMap(result[0].toColumnMap());
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados da entrega: $e');
      return null;
    }
  }

/*  Future<List<Entrega>> listarEntregas(String cpfEntregador) async {
  try {
    await verificarConexao(); // Garante que a conexão com o banco está ativa.

    // Consulta SQL para buscar entregas associadas ao CPF do entregador
    final results = await conexaoDB.connection.query(
      '''
      SELECT 
        e.pedido_id AS pedidoId,
        e.cpf_entregador AS cpfEntregador,
        e.status AS status,
        e.frete AS frete,
        c.cpf AS clienteCpf,
        c.nome AS clienteNome,
        c.endereco AS clienteEndereco,
        f.cnpj AS fornecedorCnpj,
        f.nome AS fornecedorNome
      FROM entrega e
      INNER JOIN cliente c ON e.cliente_cpf = c.cpf
      INNER JOIN fornecedor f ON e.fornecedor_cnpj = f.cnpj
      WHERE e.cpf_entregador = @cpfEntregador
      ''',
      substitutionValues: {
        'cpfEntregador': cpfEntregador,
      },
    );

    // Transforma os resultados em objetos do tipo Entrega
    return results.map((row) {
      return Entrega(
        pedidoId: row['pedidoId'] as int,
        cpf_entregador: row['cpfEntregador'] as String,
        status: Status.values.byName(row['status'] as String),
        cliente: Cliente(
          cpf: row['clienteCpf'] as String,
          nome: row['clienteNome'] as String,
          endereco: row['clienteEndereco'] as String,
        ),
        fornecedor: Fornecedor(
          cnpj: row['fornecedorCnpj'] as String,
          nome: row['fornecedorNome'] as String,
        ),
        frete: double.tryParse(row['frete'].toString()) ?? 0.0,
      );
    }).toList();
  } catch (e) {
    print('Erro ao listar entregas para o entregador: $e');
    rethrow;
  }
}*/
}

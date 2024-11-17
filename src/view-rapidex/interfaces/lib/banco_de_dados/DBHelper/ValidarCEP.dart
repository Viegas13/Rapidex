import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static Future<Map<String, dynamic>?> buscarEnderecoPorCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('erro') && data['erro'] == true) {
          return null;
        }
        return data;
      }
    } catch (e) {
      print('Erro ao buscar CEP: $e');
    }
    return null;
  }
  static Future<String?> buscarCepPorEndereco(
      String rua, String bairro, String cidade) async {
    final url = Uri.parse(
        'https://viacep.com.br/ws/$cidade/$bairro/$rua/json/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]['cep'];
        }
      }
    } catch (e) {
      print('Erro ao buscar CEP pelo endereço: $e');
    }
    return null;
  }
}

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
}

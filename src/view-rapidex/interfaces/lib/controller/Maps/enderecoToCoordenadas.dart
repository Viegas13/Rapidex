import 'package:geocoding/geocoding.dart'; // Para converter endereço em coordenadas
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Para o uso de LatLng

Future<LatLng> enderecoToCoordenadas(String endereco) async {
  try {
    // Converte o endereço em latitude e longitude
    List<Location> enderecos = await locationFromAddress(endereco);

    // Extrai as coordenadas da primeira correspondência
    double latitude = enderecos.first.latitude;
    double longitude = enderecos.first.longitude;

    // Cria o objeto LatLng com as coordenadas obtidas
    LatLng coordenada = LatLng(latitude, longitude);

    return coordenada;

    // Atualiza o estado para definir o marcador de origem
  } catch (e) {
    print('Erro na conversão para coordenadas: $e');

    throw Exception('Falha ao obter as coordenadas.');
  }
}
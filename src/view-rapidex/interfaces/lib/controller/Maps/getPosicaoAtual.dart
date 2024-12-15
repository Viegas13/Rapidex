import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getPosicaoAtual() async {
  try {
    // Solicita permissão de localização
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada');
    }

    // Obtém a posição atual
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Define a precisão para alta
      distanceFilter: 10, // Defina o intervalo de distância em metros para atualizações
    );

    // Obtém a posição atual com as novas configurações
    Position posicaoAtual = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    print("Posição Atual: " + posicaoAtual.toString());

    // Retorna como LatLng (usado pelo Google Maps)
    return LatLng(posicaoAtual.latitude, posicaoAtual.longitude);
  } catch (e) {
    print('Erro ao obter localização: $e');
    throw Exception('Não foi possível obter a localização atual.');
  }
}
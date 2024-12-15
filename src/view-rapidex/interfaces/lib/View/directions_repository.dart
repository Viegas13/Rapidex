import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:interfaces/View/.env.dart';
import 'package:interfaces/View/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origem,
    required LatLng destino,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        //'origin': '${origem.latitude},${origem.longitude}',
        'origin': '${origem.latitude},${origem.longitude}',
        'destination': '${destino.latitude},${destino.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
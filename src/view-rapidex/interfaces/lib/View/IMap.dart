import 'package:flutter/material.dart';
import 'package:interfaces/View/directions_model.dart';
import 'package:interfaces/View/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interfaces/controller/Maps/getPosicaoAtual.dart';
import 'package:interfaces/controller/Maps/enderecoToCoordenadas.dart';

class MapScreen extends StatefulWidget {
  final String enderecoFornecedor, enderecoCliente;

  const MapScreen({super.key, required this.enderecoFornecedor, required this.enderecoCliente});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  dynamic _initialCameraPosition;
  GoogleMapController? _googleMapController;
  Marker? _origem;
  Marker? _destinoFornecedor;
  Marker? _destinoCliente;
  Directions? _infoOrigemRetirada;
  Directions? _infoRetiradaEntrega;
  LatLng? _posOrigem;
  LatLng? _posDestinoRetirada;
  LatLng? _posDestinoEntrega;

  bool _isLoading = true; // Adicionando controle de carregamento

  @override
  void initState() {
    super.initState();

    try {
      carregarPosicoes();
    } catch (error) {
      print('Erro ao inicializar posições: $error');
    }
  }

  Future<void> carregarPosicoes() async {
    try {
      print("antes da posOrigem");

      setState(() async{
        _posOrigem = await getPosicaoAtual();

        print(_posOrigem);

        
        _initialCameraPosition = CameraPosition(
          target: _posOrigem!,
          zoom: 11.5,
        );   

        _posDestinoRetirada = await enderecoToCoordenadas(widget.enderecoFornecedor + ", Brasil");
        _posDestinoEntrega = await enderecoToCoordenadas(widget.enderecoCliente + ", Brasil");

        _addMarcadores();

        _isLoading = false;
      });
    } catch (error) {
      print('Erro ao carregar posições: $error');
      rethrow;
    }
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(''),
        actions: [
          if (_origem != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origem!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGEM'),
            ),
          if (_destinoFornecedor != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destinoFornecedor!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('RETIRADA'),
            ),
          if (_destinoCliente != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destinoCliente!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 239, 79, 247),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ENTREGA'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false, // Desativa botões padrão
              initialCameraPosition: _initialCameraPosition!,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                if (_origem != null) _origem!,
                if (_destinoFornecedor != null) _destinoFornecedor!,
                if (_destinoCliente != null) _destinoCliente!
              },
              polylines: {
                if (_infoOrigemRetirada != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _infoOrigemRetirada!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
                Polyline(
                  polylineId: const PolylineId('overview_polyline2'),
                  color: Colors.red,
                  width: 5,
                  points: _infoRetiradaEntrega!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
              },
            ),
          if (_infoOrigemRetirada != null && _infoRetiradaEntrega != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${somarDistancias(_infoOrigemRetirada!.totalDistance, _infoRetiradaEntrega!.totalDistance)}, ${somarTempos(_infoOrigemRetirada!.totalDuration, _infoRetiradaEntrega!.totalDuration)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // Botões de Zoom à esquerda
          Positioned(
            bottom: 220.0,
            left: 16.0,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  onPressed: () => _googleMapController?.animateCamera(CameraUpdate.zoomIn()),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8.0),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  onPressed: () => _googleMapController?.animateCamera(CameraUpdate.zoomOut()),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 200.0), // Ajusta a posição do botão
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _googleMapController!.animateCamera(
            _infoOrigemRetirada != null
                ? CameraUpdate.newLatLngBounds(_infoOrigemRetirada!.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition!),
          ),
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }

  String somarDistancias(String d1, String d2) {
    double total = double.parse(d1.split(' ')[0]) + double.parse(d2.split(' ')[0]);

    return total.toString() + " km";
  }

  String somarTempos(String t1, String t2) {
    int total = int.parse(t1.split(' ')[0]) + int.parse(t2.split(' ')[0]);

    return total.toString() + " mins";
  }

  void _addMarcadores() async {
    setState(() {
      _origem = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origem'),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: _posOrigem!,
      );

      _destinoFornecedor = Marker(
        markerId: const MarkerId('destination1'),
        infoWindow: const InfoWindow(title: 'Retirada'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: _posDestinoRetirada!,
      );

      _destinoCliente = Marker(
        markerId: const MarkerId('destination2'),
        infoWindow: const InfoWindow(title: 'Entrega'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: _posDestinoEntrega!,
      );
    });

    final directionsOrigemRetirada = await DirectionsRepository()
        .getDirections(origem: _posOrigem!, destino: _posDestinoRetirada!);
    setState(() => _infoOrigemRetirada = directionsOrigemRetirada);

    final directionsRetiradaEntrega = await DirectionsRepository()
        .getDirections(origem: _posDestinoRetirada!, destino: _posDestinoEntrega!);
    setState(() => _infoRetiradaEntrega = directionsRetiradaEntrega);
  }
}
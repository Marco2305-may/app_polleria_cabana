import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/directions.dart' hide Polyline;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_maps_webservice/directions.dart' as gws;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const kGoogleApiKey = "AIzaSyBTicrr83Nrlyb-6qr3xjk1Zzb3BZRHloQ";

class SeguimientoScreen extends StatefulWidget {
  final String direccionDestino;

  const SeguimientoScreen({super.key, required this.direccionDestino});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  // Origen fijo: coordenadas de la pollería
  final LatLng _origen = const LatLng(-12.0311, -76.9225);
  LatLng? _destino;
  GoogleMapController? _mapController;
  Set<gmaps.Polyline> _rutas = {};
  String _tiempo = "Calculando...";

  @override
  void initState() {
    super.initState();
    _calcularRuta();
  }

  Future<void> _calcularRuta() async {
    if (widget.direccionDestino.isEmpty) return;

    // 1️⃣ Geocoding: convertir dirección a coordenadas
    final geocoding = GoogleMapsGeocoding(apiKey: kGoogleApiKey);
    final destinoResultado = await geocoding.searchByAddress(widget.direccionDestino);

    if (destinoResultado.results.isEmpty) return;

    final lat = destinoResultado.results.first.geometry!.location.lat;
    final lng = destinoResultado.results.first.geometry!.location.lng;
    _destino = LatLng(lat, lng);

    // 2️⃣ Directions API: obtener ruta
    final directions = GoogleMapsDirections(apiKey: kGoogleApiKey);
    final ruta = await directions.directionsWithLocation(
      gws.Location(lat: _origen.latitude, lng: _origen.longitude),
      gws.Location(lat: lat, lng: lng),
      travelMode: gws.TravelMode.driving,
    );

    if (!ruta.isOkay) return;

    // 3️⃣ Decodificar polyline
    final polylinePoints = PolylinePoints();
    final puntos = polylinePoints.decodePolyline(ruta.routes.first.overviewPolyline.points);

    final polyline = gmaps.Polyline(
      polylineId: const gmaps.PolylineId('ruta'),
      points: puntos.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
      width: 5,
      color: Colors.brown,
    );

    // 4️⃣ Actualizar estado: polilínea y tiempo estimado
    setState(() {
      _rutas = {polyline};
      _tiempo = ruta.routes.first.legs.first.duration!.text;
    });

    // 5️⃣ Ajustar cámara para mostrar toda la ruta
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            ruta.routes.first.bounds.southwest.lat,
            ruta.routes.first.bounds.southwest.lng,
          ),
          northeast: LatLng(
            ruta.routes.first.bounds.northeast.lat,
            ruta.routes.first.bounds.northeast.lng,
          ),
        ),
        50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento del Pedido'),
        backgroundColor: Colors.brown,
      ),
      body: _destino == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _origen,
              zoom: 13,
            ),
            polylines: _rutas,
            markers: {
              Marker(
                  markerId: const MarkerId('origen'),
                  position: _origen,
                  infoWindow: const InfoWindow(title: 'Pollería')),
              Marker(
                  markerId: const MarkerId('destino'),
                  position: _destino!,
                  infoWindow:
                  const InfoWindow(title: 'Tu dirección de entrega')),
            },
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Tiempo estimado: $_tiempo 🕒',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class DireccionMapWidget extends StatefulWidget {
  final Function(String direccion, LatLng coordenadas)? onDireccionSeleccionada;

  const DireccionMapWidget({Key? key, this.onDireccionSeleccionada})
      : super(key: key);

  @override
  State<DireccionMapWidget> createState() => _DireccionMapWidgetState();
}

class _DireccionMapWidgetState extends State<DireccionMapWidget> {
  final TextEditingController _controller = TextEditingController();
  late GoogleMapsPlaces _places;
  GoogleMapController? _mapController;
  List<Prediction> _suggestions = [];
  LatLng _mapCenter = const LatLng(-12.0464, -77.0428); // Lima
  Marker? _marker;

  final String apiKey = 'AIzaSyBTicrr83Nrlyb-6qr3xjk1Zzb3BZRHloQ';

  @override
  void initState() {
    super.initState();
    _places = GoogleMapsPlaces(apiKey: apiKey);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // 🔍 Cuando el usuario escribe
  void _onTextChanged() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final response = await _places.autocomplete(
      input,
      language: 'es',
      components: [Component(Component.country, "PE")],
      types: ['address'],
    );

    if (response.isOkay && mounted) {
      setState(() => _suggestions = response.predictions);
    }
  }

  // 📍 Cuando el usuario selecciona una sugerencia
  Future<void> _selectSuggestion(Prediction p) async {
    FocusScope.of(context).unfocus(); // Cierra teclado
    final detail = await _places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      _controller.text = detail.result.formattedAddress ?? '';
      _suggestions.clear(); // ✅ Limpia sugerencias
      _mapCenter = LatLng(lat, lng);
      _marker = Marker(
        markerId: const MarkerId('seleccionado'),
        position: _mapCenter,
        infoWindow: InfoWindow(title: detail.result.formattedAddress ?? ''),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_mapCenter, 16),
    );

    // Enviar la dirección al padre (Ticket)
    widget.onDireccionSeleccionada?.call(
      detail.result.formattedAddress ?? '',
      _mapCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible( // 👈 se adapta al espacio disponible del padre
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo de texto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Escribe tu dirección...',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Sugerencias (ajustables sin romper el layout)
            if (_suggestions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final p = _suggestions[index];
                    return ListTile(
                      leading: const Icon(Icons.place, color: Colors.redAccent),
                      title: Text(p.description ?? ''),
                      onTap: () => _selectSuggestion(p),
                    );
                  },
                ),
              ),

            // 🗺️ Mapa (altura fija, sin desplazar el resto)
            Container(
              height: 250,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black26),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _mapCenter,
                    zoom: 12,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _marker != null ? {_marker!} : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}







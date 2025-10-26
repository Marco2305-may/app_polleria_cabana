import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:polleria_la_cabana_app/features/pedidos/presentation/widgets/direcion_map_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pedidos/data/pedido_repository.dart';
import '../../carrito/data/carrito_repository.dart';
import '../../carrito/presentation/carrito_item_ui.dart';

const kGoogleApiKey = "AIzaSyBTicrr83Nrlyb-6qr3xjk1Zzb3BZRHloQ";

class TicketScreen extends StatefulWidget {
  final int idPedido;
  final double total;
  final List<CarritoItemUI> items;

  const TicketScreen({
    super.key,
    required this.idPedido,
    required this.total,
    required this.items,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _direccionController = TextEditingController();
  String _metodoPago = 'Yape';
  GoogleMapController? _mapController;
  LatLng _mapCenter = const LatLng(-12.0464, -77.0428); // Lima por defecto
  Marker? _marker;

  Future<void> _handleSearch() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      mode: Mode.overlay,
      language: "es",
      components: [Component(Component.country, "pe")],
    );

    if (p != null) {
      _displayPrediction(p);
    }
  }

  Future<void> _displayPrediction(Prediction prediction) async {
    final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
    final detail = await places.getDetailsByPlaceId(prediction.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      _direccionController.text = detail.result.formattedAddress!;
      _mapCenter = LatLng(lat, lng);
      _marker = Marker(
        markerId: const MarkerId('destino'),
        position: _mapCenter,
      );
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_mapCenter, 16),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        backgroundColor: Colors.brown[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Resumen de tu pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (_, i) {
                  final item = widget.items[i];
                  return ListTile(
                    title: Text(item.nombre),
                    subtitle: Text(
                        'x${item.cantidad}  -  S/.${item.subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Text(
              'Total: S/. ${widget.total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Map
            Expanded(
              child: DireccionMapWidget(
                onDireccionSeleccionada: (direccion, latLng) {
                  print('Dirección seleccionada: $direccion');
                },
              ),
            ),



            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _metodoPago,
              items: const [
                DropdownMenuItem(value: 'Yape', child: Text('Yape')),
                DropdownMenuItem(value: 'Plin', child: Text('Plin')),
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
              ],
              onChanged: (val) => setState(() => _metodoPago = val!),
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'POS de pago vendrá con el motorizado',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:
              ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]),
              onPressed: () async {
                if (_direccionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ingrese una dirección.')),
                  );
                  return;
                }

                final repo = PedidoRepository();
                await repo.actualizarPedido(
                  widget.idPedido,
                  _direccionController.text,
                  _metodoPago,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Pedido confirmado. El motorizado llegará con POS para pagar.')),
                );

                Navigator.pop(context);
              },
              child: const Text('Confirmar envío'),
            ),
          ],
        ),
      ),
    );
  }
}


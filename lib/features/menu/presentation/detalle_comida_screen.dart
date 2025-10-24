import 'package:flutter/material.dart';
import '../data/comida_model.dart';

class DetalleComidaScreen extends StatefulWidget {
  final Comida comida;

  const DetalleComidaScreen({super.key, required this.comida});

  @override
  State<DetalleComidaScreen> createState() => _DetalleComidaScreenState();
}

class _DetalleComidaScreenState extends State<DetalleComidaScreen> {
  int cantidad = 1;

  // Lista de cremas disponibles
  final List<String> cremas = ['Mayonesa', 'Ají', 'Kétchup', 'Mostaza'];
  final Set<String> cremasSeleccionadas = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comida.nombre),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.comida.imagen.isNotEmpty
                    ? Image.asset(widget.comida.imagen, height: 220, fit: BoxFit.cover)
                    : Image.asset('assets/images/default_food.jpg', height: 220, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.comida.descripcion, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Precio: S/. ${widget.comida.precio.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Seleccione las cremas (1 bolsita por pedido)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...cremas.map((c) => CheckboxListTile(
              title: Text(c),
              value: cremasSeleccionadas.contains(c),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    cremasSeleccionadas.add(c);
                  } else {
                    cremasSeleccionadas.remove(c);
                  }
                });
              },
            )),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Cantidad:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    if (cantidad > 1) setState(() => cantidad--);
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$cantidad', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () => setState(() => cantidad++),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.brown[700],
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Agregado ${widget.comida.nombre} x$cantidad al carrito con cremas: ${cremasSeleccionadas.join(', ')}'),
                  ),
                );
                // Aquí podrías llamar al método para agregarlo a la tabla Carrito
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Pedir'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:polleria_la_cabana_app/features/pedidos/data/pedido_repository.dart';
import '../../carrito/data/carrito_repository.dart';
import '../../carrito/presentation/carrito_item_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
        backgroundColor: Colors.brown[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Resumen de tu pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (_, i) {
                  final item = widget.items[i];
                  return ListTile(
                    title: Text(item.nombre),
                    subtitle: Text('x${item.cantidad}  -  S/.${item.subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            Text('Total: S/. ${widget.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _direccionController,
              decoration: const InputDecoration(
                labelText: 'Dirección de entrega',
                border: OutlineInputBorder(),
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
            const SizedBox(height: 20),
            Text('POS de pago vendrá con el motorizado', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]),
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
                  const SnackBar(content: Text('Pedido confirmado. El motorizado llegará con POS para pagar.')),
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

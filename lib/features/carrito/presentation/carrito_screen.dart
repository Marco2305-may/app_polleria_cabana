import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../pedidos/presentation/ticket_screen.dart';
import '../data/carrito_repository.dart';
import '../domain/clear_carrito_usercase.dart';
import '../domain/confirmate_pedido.dart';
import '../domain/get_carrito_usercase.dart';
import '../domain/remove_from_carrito_usercase.dart';
import 'carrito_item_ui.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  late final CarritoRepository _repo;
  late final GetCarritoUseCase _getCarritoUseCase;
  late final RemoveFromCarritoUseCase _removeUseCase;
  late final ClearCarritoUseCase _clearUseCase;

  List<CarritoItemUI> _items = [];

  @override
  void initState() {
    super.initState();
    _repo = CarritoRepository();
    _getCarritoUseCase = GetCarritoUseCase(_repo);
    _removeUseCase = RemoveFromCarritoUseCase(_repo);
    _clearUseCase = ClearCarritoUseCase(_repo);
    _loadCarrito();
  }

  Future<void> _loadCarrito() async {
    final items = await _getCarritoUseCase.execute();
    setState(() => _items = items);
  }

  double get _total => _items.fold(0, (sum, item) => sum + item.subtotal);

  void _removeItem(int idCarrito) async {
    await _removeUseCase.execute(idCarrito);
    _loadCarrito();
  }

  void _clearCarrito() async {
    await _clearUseCase.execute();
    _loadCarrito();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Vaciar carrito',
            onPressed: () {
              if (_items.isEmpty) return;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Confirmar'),
                  content: const Text('¿Desea vaciar el carrito?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        _clearCarrito();
                        Navigator.pop(context);
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Lista de items que ocupa todo el espacio disponible
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: item.imagen.isNotEmpty
                          ? Image.asset(item.imagen, width: 50, fit: BoxFit.cover)
                          : Image.asset('assets/images/default_food.jpg',
                          width: 50, fit: BoxFit.cover),
                      title: Text(item.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.descripcion,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('Cantidad: ${item.cantidad}'),
                          Text('Precio unitario: S/. ${item.precio.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'S/. ${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _removeItem(item.idCarrito),
                            ),
                          ],
                        ),
                      ),

                    ),
                  );
                },
              ),
            ),

            // Total y botón
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.brown[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: S/. ${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_items.isEmpty) return;

                      final prefs = await SharedPreferences.getInstance();
                      final idUsuario = prefs.getInt('idUsuario');

                      if (idUsuario == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error: usuario no encontrado. Inicia sesión.')),
                        );
                        return;
                      }

                      final confirmarPedido = ConfirmarPedidoUseCase(_repo);
                      final idPedido = await confirmarPedido.execute(idUsuario);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketScreen(
                            idPedido: idPedido,
                            total: _total,
                            items: _items,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]),
                    child: const Text('Confirmar Pedido'),
                  ),
                ],
              ),
              ),
          ],
        ),
      ),


    );
  }
}


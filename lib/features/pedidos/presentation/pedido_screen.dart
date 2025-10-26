import 'package:flutter/material.dart';
import '../../pedidos/data/pedido_repository.dart';
import 'Seguimiento_screen.dart';


class PedidoScreen extends StatefulWidget {
  const PedidoScreen({super.key});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  List<Map<String, dynamic>> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final repo = PedidoRepository();
    final pedidos = await repo.obtenerPedidos();
    setState(() => _pedidos = pedidos);
  }

  Future<void> _cancelarPedido(int idPedido) async {
    final confirmar = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Cancelar pedido?'),
        content: const Text(
          'Si cancelas más de 3 veces, podríamos suspender tu cuenta.',
        ),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Sí, cancelar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      final repo = PedidoRepository();
      await repo.eliminarPedido(idPedido);
      _cargarPedidos();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido cancelado con éxito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: _pedidos.isEmpty
          ? const Center(
        child: Text(
          'No tienes pedidos activos 📦',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _pedidos.length,
        itemBuilder: (context, i) {
          final p = _pedidos[i];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text('Pedido ${p['id_pedido']}'),
              subtitle: Text('Estado: ${p['estado']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => _cancelarPedido(p['id_pedido']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeguimientoScreen(
                            direccionDestino: p['direccion'],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



import 'package:flutter/material.dart';

class PedidoScreen extends StatelessWidget {
  const PedidoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Aquí podrás ver el estado de tus pedidos 📦',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


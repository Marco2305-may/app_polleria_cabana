import 'package:flutter/material.dart';

class ReservacionScreen extends StatelessWidget {
  const ReservacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservaciones'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Aquí podrás hacer una reservación 🪑',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

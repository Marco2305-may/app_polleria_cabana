import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';
import '../../perfil/data/perfil_repository.dart';
import '../data/reservacion_repository.dart';
import '../data/reservasion_model.dart';
import 'package:sqflite/sqflite.dart';
import 'reservacion_form_screen.dart';

class ReservacionScreen extends StatefulWidget {
  final int idUsuario;

  const ReservacionScreen({super.key, required this.idUsuario});

  @override
  State<ReservacionScreen> createState() => _ReservacionScreenState();
}

class _ReservacionScreenState extends State<ReservacionScreen> {
  late ReservacionRepository repo;
  List<Reservacion> reservas = [];

  @override
  void initState() {
    super.initState();
    _initDbAndLoad();
  }

  Future<void> _initDbAndLoad() async {
    final db = await DatabaseHelper.instance.database; // <- usa polleria.db
    repo = ReservacionRepository(db: db); // <--- ¡FALTA ESTO!

    await _cargarReservas();

    // Ahora puedes usar usuarioRepo para obtener usuarios, reservaciones, etc.
  }

  Future<void> _cargarReservas() async {
    final data = await repo.obtenerReservaciones(widget.idUsuario);
    setState(() => reservas = data);
  }

  void _abrirFormulario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservacionFormScreen(
          idUsuario: widget.idUsuario,
          repo: repo,
          onReservacionCreada: _cargarReservas,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservaciones'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _abrirFormulario,
            child: const Text('Hacer nueva reservación'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reservas.length,
              itemBuilder: (_, i) {
                final r = reservas[i];
                return ListTile(
                  title: Text('Fecha: ${r.fecha} - Hora: ${r.hora}'),
                  subtitle: Text('${r.invitados} invitados\n${r.detalle}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



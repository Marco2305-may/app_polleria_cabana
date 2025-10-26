import 'package:flutter/material.dart';
import '../data/reservacion_repository.dart';
import '../data/reservasion_model.dart';

class ReservacionFormScreen extends StatefulWidget {
  final int idUsuario;
  final ReservacionRepository repo;
  final VoidCallback onReservacionCreada;

  const ReservacionFormScreen({
    super.key,
    required this.idUsuario,
    required this.repo,
    required this.onReservacionCreada,
  });

  @override
  State<ReservacionFormScreen> createState() => _ReservacionFormScreenState();
}

class _ReservacionFormScreenState extends State<ReservacionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fecha;
  TimeOfDay? _hora;
  int _invitados = 1;
  final _detalleController = TextEditingController();

  // Seleccionar fecha con DatePicker
  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 365)),
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  // Seleccionar hora con TimePicker (solo 0–22)
  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (hora != null) {
      if (hora.hour >= 0 && hora.hour <= 22) {
        setState(() => _hora = hora);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione una hora entre 12am y 10pm')),
        );
      }
    }
  }

  // Formatear fecha manualmente: YYYY-MM-DD
  String _formatearFecha(DateTime fecha) {
    return "${fecha.year}-${fecha.month.toString().padLeft(2,'0')}-${fecha.day.toString().padLeft(2,'0')}";
  }

  // Guardar la reservación
  void _guardarReservacion() async {
    if (_fecha == null || _hora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar fecha y hora')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final nueva = Reservacion(
        idUsuario: widget.idUsuario,
        fecha: _formatearFecha(_fecha!),
        hora: _hora!.format(context),
        invitados: _invitados,
        detalle: _detalleController.text,
      );
      await widget.repo.crearReservacion(nueva);
      widget.onReservacionCreada();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reservación'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Fecha
              ListTile(
                title: const Text('Fecha'),
                subtitle: Text(_fecha != null ? _formatearFecha(_fecha!) : 'Seleccione una fecha'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _seleccionarFecha,
                ),
              ),
              // Hora
              ListTile(
                title: const Text('Hora'),
                subtitle: Text(_hora != null ? _hora!.format(context) : 'Seleccione una hora'),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: _seleccionarHora,
                ),
              ),
              // Invitados
              DropdownButtonFormField<int>(
                value: _invitados,
                decoration: const InputDecoration(labelText: 'Número de invitados'),
                items: List.generate(12, (i) => i + 1)
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (val) => setState(() => _invitados = val!),
              ),
              // Detalle
              TextFormField(
                controller: _detalleController,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Detalle (cumpleaños, promoción, etc.)',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ingrese un detalle';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarReservacion,
                child: const Text('Guardar Reservación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


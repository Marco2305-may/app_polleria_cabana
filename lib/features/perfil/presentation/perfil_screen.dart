import 'package:flutter/material.dart';
import '../data/perfil_model.dart';
import '../data/perfil_repository.dart';

class PerfilScreen extends StatefulWidget {
  final int idUsuario;
  final UsuarioRepository repo;

  const PerfilScreen({super.key, required this.idUsuario, required this.repo});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? usuario;

  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final data = await widget.repo.obtenerUsuario(widget.idUsuario);
    if (!mounted) return;

    if (data != null) {
      usuario = data;
      _nombreController.text = usuario!.nombreCompleto;
      _correoController.text = usuario!.correo;
      _telefonoController.text = usuario!.telefono ?? '';
      _contrasenaController.text = usuario!.contrasena;
    }

    setState(() {
      _cargando = false;
    });
  }

  Future<void> _actualizarUsuario() async {
    if (usuario != null) {
      usuario!.nombreCompleto = _nombreController.text;
      usuario!.correo = _correoController.text;
      usuario!.telefono = _telefonoController.text;
      usuario!.contrasena = _contrasenaController.text;

      await widget.repo.actualizarUsuario(usuario!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado correctamente')),
        );
        setState(() {}); // refresca pantalla
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (usuario == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Usuario no encontrado',
            style: TextStyle(fontSize: 18, color: Colors.red[700]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextFormField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _contrasenaController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _actualizarUsuario,
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}





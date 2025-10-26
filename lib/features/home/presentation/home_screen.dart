import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';
import '../../menu/presentation/menu_screen.dart';
import '../../reservaciones/presentation/reservacion_screen.dart';
import '../../pedidos/presentation/pedido_screen.dart';
import '../../perfil/presentation/perfil_screen.dart';
import '../../perfil/data/perfil_repository.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _idUsuario = 1; // Id del usuario logueado

  List<Widget>? _screens;
  late UsuarioRepository _usuarioRepo;

  @override
  void initState() {
    super.initState();
    _initRepos();
  }

  Future<void> _initRepos() async {
    final db = await DatabaseHelper.instance.database; // <- Usar polleria.db
    _usuarioRepo = UsuarioRepository(db: db);

    setState(() {
      _screens = [
        MenuScreen(),
        ReservacionScreen(idUsuario: _idUsuario),
        PedidoScreen(),
        PerfilScreen(idUsuario: _idUsuario, repo: _usuarioRepo),
      ];
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screens == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _screens![_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.brown[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menú'),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Reservar'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}







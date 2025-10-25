// lib/features/auth/presentation/login_screen.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import '../data/auth_repository.dart';
import '../data/user_model.dart';
import '../../home/presentation/home_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final authRepo = AuthRepository();

  void _login() async {
    Usuario? user = await authRepo.login(
      _correoController.text,
      _contrasenaController.text,
    );

    if (user != null) {
      //Guardar usuario logueado localmente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('idUsuario', user.idUsuario!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido, ${user.nombreCompleto}')),
      );
      // Aquí irías a la pantalla principal de tu app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/Pollo_login.png',
              fit: BoxFit.cover,
            ),
          ),
          // Capa semi-transparente para resaltar campos
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Contenido del login
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(height: 60), // espacio desde arriba
              // Título de la app
              Center(
                child: Text(
                  'Pollería "La Cabaña"',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // título en blanco
                    shadows: [
                      Shadow( // sombra para que resalte sobre la imagen
                        blurRadius: 4,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),

              // Campo de correo
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.text,
                    enableSuggestions: false ,
                    autocorrect: false,
                    obscureText: false,
                    autofillHints: null,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      labelStyle: TextStyle(color: Colors.black87), // letras moradas
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              SizedBox(height: 10),
              // Campo de contraseña
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.black87),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              // Boton para ingresar
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B5E3C), // marrón cálido tipo pollo dorado
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // bordes redondeados
                  ),
                ),
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                    fontSize: 20,               // más grande
                    fontWeight: FontWeight.bold, // negrita
                    color: Colors.white,        // texto blanco
                    letterSpacing: 1.2,         // espaciado elegante
                    shadows: [
                      Shadow(
                        color: Colors.black45, // sombra para resaltar sobre el botón
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              //Boton para registrarse en caso no tenga cuenta
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterScreen()),
                  );
                },
                child: Text(
                  '¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}



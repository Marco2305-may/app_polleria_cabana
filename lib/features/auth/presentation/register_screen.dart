// lib/features/auth/presentation/register_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../data/auth_repository.dart';
import '../data/user_model.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final authRepo = AuthRepository();

  void _register() async {
    Usuario nuevoUsuario = Usuario(
      nombreCompleto: _nombreController.text,
      correo: _correoController.text,
      telefono: _telefonoController.text,
      contrasena: _contrasenaController.text,
    );

    bool success = await authRepo.registerUser(nuevoUsuario);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado con éxito')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar, verifica tus datos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Imagen de fondo fija
          Positioned.fill(
            child: Image.asset(
              'assets/images/Pollo_login.png',
              fit: BoxFit.cover,
            ),
          ),
          // Capa semi-transparente
          Container(color: Colors.black.withOpacity(0.3)),

          // Contenido scrollable
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Text(
                    'Regístrate en Pollería "La Cabaña"',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Campo nombre completo
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _nombreController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false ,
                      autocorrect: false,
                      obscureText: false,
                      autofillHints: null,
                      decoration: InputDecoration(
                        labelText: 'Nombre completo',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo correo
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
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo teléfono
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextFormField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false ,
                      autocorrect: false,
                      obscureText: false,
                      autofillHints: null,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Campo contraseña
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
                SizedBox(height: 20),

                // Botón registrar
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B5E3C), // marrón cálido tipo pollo dorado
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Botón para volver al login
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



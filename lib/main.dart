import 'package:flutter/material.dart';
import 'package:polleria_la_cabana_app/features/auth/presentation/ombording_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; // Inicializa la DB sin mostrar mensajes
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pollería La Cabaña',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: OnboardingScreen(), // Arranca directamente en login
    );
  }
}

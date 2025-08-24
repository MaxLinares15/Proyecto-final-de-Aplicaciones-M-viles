import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'public/inicio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ministerio de Medio Ambiente')),
      drawer: const AppDrawer(logged: true),
      body: const InicioScreen(),
    );
  }
}

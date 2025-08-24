import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisReportesScreen extends StatefulWidget {
  const MisReportesScreen({super.key});

  @override
  State<MisReportesScreen> createState() => _MisReportesScreenState();
}

class _MisReportesScreenState extends State<MisReportesScreen> {
  List<Map<String, dynamic>> _reportes = [];

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  /// Cargar reportes desde almacenamiento local
  Future<void> _cargarReportes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("mis_reportes") ?? [];
    setState(() {
      _reportes = data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  /// Borrar todos los reportes (opcional)
  Future<void> _borrarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("mis_reportes");
    setState(() => _reportes = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reportes"),
        actions: [
          if (_reportes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: _borrarTodo,
            )
        ],
      ),
      body: _reportes.isEmpty
          ? const Center(child: Text("No tienes reportes guardados"))
          : ListView.builder(
              itemCount: _reportes.length,
              itemBuilder: (context, i) {
                final r = _reportes[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(r["titulo"] ?? "Sin título"),
                    subtitle: Text(r["descripcion"] ?? ""),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (r["latitud"] != null && r["longitud"] != null)
                          Text("📍 ${r["latitud"]}, ${r["longitud"]}"),
                        Text(r["fecha"] ?? ""),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

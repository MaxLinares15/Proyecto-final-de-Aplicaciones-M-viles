import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class MisReportesScreen extends StatefulWidget {
  const MisReportesScreen({super.key});

  @override
  State<MisReportesScreen> createState() => _MisReportesScreenState();
}

class _MisReportesScreenState extends State<MisReportesScreen> {
  List<Map<String, dynamic>> _reportes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  /// Cargar reportes desde la API
  Future<void> _cargarReportes() async {
    try {
      final res = await ApiService.getMisReportes();
      final list = (res['datos'] ?? res['data'] ?? res['reportes'] ?? []) as List;

      setState(() {
        _reportes = list.cast<Map<String, dynamic>>();
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando reportes: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reportes")),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _reportes.isEmpty
              ? const Center(child: Text("No tienes reportes registrados"))
              : RefreshIndicator(
                  onRefresh: _cargarReportes,
                  child: ListView.builder(
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
                              if (r["fecha"] != null) Text(r["fecha"]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class MapaReportesScreen extends StatefulWidget {
  const MapaReportesScreen({super.key});

  @override
  State<MapaReportesScreen> createState() => _MapaReportesScreenState();
}

class _MapaReportesScreenState extends State<MapaReportesScreen> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.getMisReportes();
      final list = (res['datos'] ?? res['data'] ?? []) as List;

      final reps = list.map((e) => Reporte.fromJson(e)).toList();

      setState(() {
        _markers.clear();
        for (final r in reps) {
          _markers.add(
            Marker(
              markerId: MarkerId(r.codigo ?? 'sin_codigo'),
              position: LatLng(r.lat, r.lng),
              infoWindow: InfoWindow(
                title: r.titulo,
                snippet: r.estado,
              ),
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando reportes: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Reportes')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.5, -69.9), // Centro aproximado RD
          zoom: 7,
        ),
        markers: _markers,
      ),
    );
  }
}

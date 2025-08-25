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
  GoogleMapController? _mapController;
  bool _cargando = true;

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
        _cargando = false;
      });

      // Ajusta cámara a los marcadores
      if (_markers.isNotEmpty && _mapController != null) {
        _fitBounds();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando reportes: $e")),
      );
    }
  }

  /// Ajusta la cámara para que se vean todos los marcadores
  void _fitBounds() {
    if (_markers.isEmpty) return;

    LatLngBounds bounds;
    final latitudes = _markers.map((m) => m.position.latitude);
    final longitudes = _markers.map((m) => m.position.longitude);

    bounds = LatLngBounds(
      southwest: LatLng(latitudes.reduce((a, b) => a < b ? a : b),
          longitudes.reduce((a, b) => a < b ? a : b)),
      northeast: LatLng(latitudes.reduce((a, b) => a > b ? a : b),
          longitudes.reduce((a, b) => a > b ? a : b)),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Reportes')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(18.5, -69.9), // Centro de RD como fallback
                  zoom: 7,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_markers.isNotEmpty) {
                    _fitBounds();
                  }
                },
              ),
            ),
    );
  }
}

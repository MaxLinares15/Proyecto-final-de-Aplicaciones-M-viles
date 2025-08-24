import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class MapaAreasScreen extends StatefulWidget {
  const MapaAreasScreen({super.key});

  @override
  State<MapaAreasScreen> createState() => _MapaAreasScreenState();
}

class _MapaAreasScreenState extends State<MapaAreasScreen> {
  final Set<Marker> _markers = {};
  GoogleMapController? _map;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await ApiService.getAreasProtegidas();
      final list = (res['datos'] ?? res['data'] ?? []) as List;

      final areas = list.map((e) => Area.fromJson(e)).toList();

      setState(() {
        _markers.clear();
        for (final a in areas) {
          _markers.add(
            Marker(
              markerId: MarkerId('${a.id}'),
              position: LatLng(a.lat, a.lng),
              infoWindow: InfoWindow(
                title: a.nombre,
                snippet: a.descripcion,
              ),
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando áreas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa Áreas Protegidas')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.5, -69.9),
          zoom: 7,
        ),
        markers: _markers,
        onMapCreated: (g) => _map = g,
      ),
    );
  }
}

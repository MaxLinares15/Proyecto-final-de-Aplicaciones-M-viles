import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  _ServiciosScreenState createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  late Future<List<Servicio>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<Servicio>> _load() async {
    final res = await ApiService.getServicios(); // ✅ método correcto
    final list = (res['datos'] ?? res['data'] ?? []) as List;
    return list.map((e) => Servicio.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: FutureBuilder<List<Servicio>>(
        future: future,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text('Error: ${s.error}'));
          }

          final data = s.data ?? [];
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No hay servicios disponibles",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final it = data[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[700],
                    child: const Icon(Icons.handshake, color: Colors.white),
                  ),
                  title: Text(
                    it.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      it.descripcion,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

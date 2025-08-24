import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class MedidasScreen extends StatefulWidget {
  const MedidasScreen({super.key});

  @override
  State<MedidasScreen> createState() => _MedidasScreenState();
}

class _MedidasScreenState extends State<MedidasScreen> {
  late Future<List<Medida>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<Medida>> _load() async {
    final res = await ApiService.getMedidas(); // 👈 corregido
    final list = (res['datos'] ?? res['data'] ?? []) as List;
    return list.map((e) => Medida.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medidas Ambientales')),
      body: FutureBuilder<List<Medida>>(
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
            return const Center(child: Text("No hay medidas disponibles"));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final m = data[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ExpansionTile(
                  title: Text(
                    m.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(m.contenido),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

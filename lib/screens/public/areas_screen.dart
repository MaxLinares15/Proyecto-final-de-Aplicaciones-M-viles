import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class AreasProtegidasScreen extends StatefulWidget {
  const AreasProtegidasScreen({super.key});

  @override
  State<AreasProtegidasScreen> createState() => _AreasProtegidasScreenState();
}

class _AreasProtegidasScreenState extends State<AreasProtegidasScreen> {
  late Future<List<Area>> future;
  String q = '';

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<Area>> _load() async {
    final res = await ApiService.getAreasProtegidas(); // 👈 corregido
    final list = (res['datos'] ?? res['data'] ?? []) as List;
    return list.map((e) => Area.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Áreas Protegidas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar...',
              ),
              onChanged: (v) => setState(() => q = v.toLowerCase()),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Area>>(
              future: future,
              builder: (c, s) {
                if (s.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (s.hasError) {
                  return Center(child: Text('Error: ${s.error}'));
                }
                var data = s.data ?? [];
                if (q.isNotEmpty) {
                  data = data
                      .where((a) => a.nombre.toLowerCase().contains(q))
                      .toList();
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final a = data[i];
                    return ListTile(
                      title: Text(a.nombre),
                      subtitle: Text('Lat: ${a.lat}, Lng: ${a.lng}'),
                      onTap: () => showDialog(
                        context: c,
                        builder: (_) => AlertDialog(
                          title: Text(a.nombre),
                          content: Text(a.descripcion),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

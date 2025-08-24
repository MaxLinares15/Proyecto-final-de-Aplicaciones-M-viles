import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';

class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  late Future<List<Noticia>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<Noticia>> _load() async {
    final res = await ApiService.getNoticias();
    final list = (res['datos'] ?? res['data'] ?? []) as List;
    return list.map((e) => Noticia.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias Ambientales')),
      body: FutureBuilder<List<Noticia>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay noticias disponibles.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final n = data[i];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (n.imagen.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: n.imagen,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ListTile(
                      title: Text(n.titulo),
                      subtitle: Text(n.fecha),
                    ),
                    OverflowBar(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Aquí puedes abrir detalle o link externo
                          },
                          child: const Text('Abrir'),
                        ),
                      ],
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

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosEducativosScreen extends StatefulWidget {
  const VideosEducativosScreen({super.key});

  @override
  State<VideosEducativosScreen> createState() => _VideosEducativosScreenState();
}

class _VideosEducativosScreenState extends State<VideosEducativosScreen> {
  late Future<List<VideoEdu>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<List<VideoEdu>> _load() async {
    final res = await ApiService.getVideos();
    final list = (res['datos'] ?? res['data'] ?? []) as List;
    return list.map((e) => VideoEdu.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos Educativos'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<VideoEdu>>(
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
            return const Center(child: Text("No hay videos disponibles"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (_, i) {
              final it = data[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: const Icon(
                    Icons.play_circle_fill,
                    color: Colors.blue,
                    size: 36,
                  ),
                  title: Text(
                    it.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    if (it.url.isEmpty) return;
                    final uri = Uri.parse(it.url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

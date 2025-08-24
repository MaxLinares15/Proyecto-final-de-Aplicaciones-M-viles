import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SobreNosotrosScreen extends StatefulWidget {
  const SobreNosotrosScreen({super.key});

  @override
  State<SobreNosotrosScreen> createState() => _SobreNosotrosScreenState();
}

class _SobreNosotrosScreenState extends State<SobreNosotrosScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) => setState((){}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre Nosotros')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Historia', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('El Ministerio de Medio Ambiente de la República Dominicana trabaja para la protección y conservación de los recursos naturales...'),
          const SizedBox(height: 16),
          const Text('Misión y Visión', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Misión: Garantizar la sostenibilidad ambiental.\nVisión: Un país resiliente y verde.'),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16/9,
            child: _controller.value.isInitialized ? VideoPlayer(_controller) : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 8),
          Row(children: [
            IconButton(onPressed: (){ _controller.play(); }, icon: const Icon(Icons.play_arrow)),
            IconButton(onPressed: (){ _controller.pause(); }, icon: const Icon(Icons.pause)),
          ])
        ],
      ),
    );
  }
}
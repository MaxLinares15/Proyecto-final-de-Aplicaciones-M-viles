import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  void _call(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _tg(String handle) async {
    final uri = Uri.parse('https://t.me/$handle');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Equipo de Desarrollo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _DevCard(
            nombre: 'Max Linares',
            matricula: '2023-1048',
            telefono: '8297756817',
            telegram: 'MaxLJ1',
            fotoUrl: 'assets/perfil.jpg',
          ),
        ],
      ),
    );
  }
}

class _DevCard extends StatelessWidget {
  final String nombre;
  final String matricula;
  final String telefono;
  final String telegram;
  final String fotoUrl;

  const _DevCard({
    required this.nombre,
    required this.matricula,
    required this.telefono,
    required this.telegram,
    required this.fotoUrl,
  });

  @override
  Widget build(BuildContext c) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: fotoUrl.startsWith('http')
                  ? NetworkImage(fotoUrl)
                  : AssetImage(fotoUrl) as ImageProvider,
            ),
            const SizedBox(height: 12),
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Matrícula: $matricula',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Text('Tel: $telefono'),
            const SizedBox(height: 6),
            Text('Telegram: @$telegram'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => const AcercaDeScreen()._call(telefono),
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.green.shade50,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => const AcercaDeScreen()._tg(telegram),
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Slide('Protejamos nuestros bosques',
          'https://images.unsplash.com/photo-1506765515384-028b60a970df'),
      _Slide('Cuidar el agua es vida',
          'https://images.unsplash.com/photo-1508873699372-7aeab60b44ab'),
      _Slide('Reduce, Reutiliza y Recicla',
          'https://images.unsplash.com/photo-1484406566174-9da000fda645'),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          CarouselSlider(
            items: items.map((s) => _SlideWidget(slide: s)).toList(),
            options: CarouselOptions(
                height: 220, autoPlay: true, enlargeCenterPage: true),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Acciones del Ministerio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _ActionChip(Icons.park, 'Reforestación'),
              _ActionChip(Icons.water_drop, 'Protección del Agua'),
              _ActionChip(Icons.recycling, 'Reciclaje'),
              _ActionChip(Icons.energy_savings_leaf, 'Educación Ambiental'),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Slide {
  final String title;
  final String url;
  _Slide(this.title, this.url);
}

class _SlideWidget extends StatelessWidget {
  final _Slide slide;
  const _SlideWidget({required this.slide});
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          Image.network(slide.url, fit: BoxFit.cover),
          Container(color: Colors.black38),
          Center(
              child: Text(slide.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))
        ],
      );
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionChip(this.icon, this.label);
  @override
  Widget build(BuildContext ctx) =>
      Chip(label: Text(label), avatar: Icon(icon, color: Colors.green));
}

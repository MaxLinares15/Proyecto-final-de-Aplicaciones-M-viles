import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class NormativasScreen extends StatelessWidget {
  const NormativasScreen({super.key});

  Future<List<dynamic>> _fetchNormas() async {
    final res = await ApiService.request("api/normativas", method: "GET");
    return res["datos"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Normativas Ambientales")),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchNormas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay normativas disponibles"));
          }
          final normas = snapshot.data!;
          return ListView.builder(
            itemCount: normas.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(normas[i]["titulo"]),
              subtitle: Text(normas[i]["descripcion"]),
            ),
          );
        },
      ),
    );
  }
}

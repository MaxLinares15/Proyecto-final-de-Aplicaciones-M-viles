// lib/screens/reportar/reportar_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class ReportarScreen extends StatefulWidget {
  const ReportarScreen({super.key});

  @override
  State<ReportarScreen> createState() => _ReportarScreenState();
}

class _ReportarScreenState extends State<ReportarScreen> {
  final _formKey = GlobalKey<FormState>();
  final tituloCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lngCtrl = TextEditingController();
  File? _image;
  bool loading = false;

  Future<void> _pick() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30, // reducir tamaño para evitar error 400
    );
    if (x != null) {
      setState(() => _image = File(x.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes tomar una foto")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final fotoB64 = base64Encode(await _image!.readAsBytes());

      final res = await ApiService.reportarDanio(
        titulo: tituloCtrl.text.trim(),
        descripcion: descCtrl.text.trim(),
        fotoBase64: fotoB64,
        lat: double.parse(latCtrl.text.trim()),
        lng: double.parse(lngCtrl.text.trim()),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['mensaje'] ?? 'Reporte enviado')),
      );

      // ✅ limpiar si el backend realmente creó el reporte
      if (res.containsKey('reporte')) {
        tituloCtrl.clear();
        descCtrl.clear();
        latCtrl.clear();
        lngCtrl.clear();
        setState(() => _image = null);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar Daño Ambiental')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pick,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Foto'),
                ),
                const SizedBox(width: 12),
                if (_image != null)
                  Expanded(child: Image.file(_image!, height: 120)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: latCtrl,
                    decoration: const InputDecoration(labelText: 'Latitud'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: lngCtrl,
                    decoration: const InputDecoration(labelText: 'Longitud'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}

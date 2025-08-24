import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class VoluntariadoScreen extends StatefulWidget {
  const VoluntariadoScreen({super.key});
  @override
  State<VoluntariadoScreen> createState() => _VoluntariadoScreenState();
}

class _VoluntariadoScreenState extends State<VoluntariadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final cedulaCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final claveCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  bool loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final res = await ApiService.registrarVoluntario(
        cedula: cedulaCtrl.text.trim(),
        nombre: nombreCtrl.text.trim(),
        correo: correoCtrl.text.trim(),
        clave: claveCtrl.text.trim(),
        telefono: telCtrl.text.trim(),
      );

      if (res['exito'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['mensaje'] ?? 'Enviado')));
        cedulaCtrl.clear();
        nombreCtrl.clear();
        correoCtrl.clear();
        claveCtrl.clear();
        telCtrl.clear();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['mensaje'] ?? 'Error')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voluntariado')),
      body: Form(
          key: _formKey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            TextFormField(
                controller: cedulaCtrl,
                decoration: const InputDecoration(labelText: 'Cédula'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
            TextFormField(
                controller: nombreCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nombre y Apellido'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
            TextFormField(
                controller: correoCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Correo inválido'),
            TextFormField(
                controller: claveCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) =>
                    (v ?? '').length < 6 ? 'Mínimo 6 caracteres' : null),
            TextFormField(
                controller: telCtrl,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: loading ? null : _submit,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Enviar'))
          ])),
    );
  }
}

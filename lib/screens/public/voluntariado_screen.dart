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
  final apellidoCtrl = TextEditingController();
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
        apellido: apellidoCtrl.text.trim(),
        correo: correoCtrl.text.trim(),
        password: claveCtrl.text.trim(),
        telefono: telCtrl.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['mensaje'] ?? 'Registro exitoso')),
      );

      if (res['exito'] == true) {
        cedulaCtrl.clear();
        nombreCtrl.clear();
        apellidoCtrl.clear();
        correoCtrl.clear();
        claveCtrl.clear();
        telCtrl.clear();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Voluntario")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: cedulaCtrl,
              decoration: const InputDecoration(labelText: 'Cédula'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: apellidoCtrl,
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: correoCtrl,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: claveCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            TextFormField(
              controller: telCtrl,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }
}

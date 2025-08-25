import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cedulaCtrl = TextEditingController();
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _apellidoCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _telefonoCtrl = TextEditingController();
  final TextEditingController _matriculaCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final response = await ApiService.register(
        cedula: _cedulaCtrl.text.trim(),
        nombre: _nombreCtrl.text.trim(),
        apellido: _apellidoCtrl.text.trim(),
        correo: _correoCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim(),
        matricula: _matriculaCtrl.text.trim(),
      );

      print("🔎 Respuesta de API registro: $response"); // Debug

      if (!mounted) return;

      if (response['exito'] == true || response['ok'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso, inicia sesión")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Error: ${response['mensaje'] ?? 'Intente de nuevo'}")),
        );
      }
    } catch (e) {
      print("Error de conexión: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _cedulaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Cédula"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese su cédula" : null,
              ),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese su nombre" : null,
              ),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese su apellido" : null,
              ),
              TextFormField(
                controller: _correoCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (v) => v == null || !v.contains("@")
                    ? "Ingrese un correo válido"
                    : null,
              ),
              TextFormField(
                controller: _telefonoCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Teléfono"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese su teléfono" : null,
              ),
              TextFormField(
                controller: _matriculaCtrl,
                decoration: const InputDecoration(labelText: "Matrícula"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese su matrícula" : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
                validator: (v) =>
                    v == null || v.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2)
                    : const Icon(Icons.person_add),
                label: const Text("Registrarse"),
                onPressed: _loading ? null : _register,
              ),
              TextButton(
                child: const Text("¿Ya tienes cuenta? Inicia sesión"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

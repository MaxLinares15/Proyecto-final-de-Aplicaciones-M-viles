import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CambiarPasswordScreen extends StatefulWidget {
  const CambiarPasswordScreen({super.key});

  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final emailCtrl = TextEditingController();
  final codigoCtrl = TextEditingController();
  final nuevaClaveCtrl = TextEditingController();
  bool loading = false;

  Future<void> _cambiarPassword() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.request(
        "auth/reset",
        method: "POST",
        body: {
          "correo": emailCtrl.text.trim(),
          "codigo": "1234",
          "nueva_password": nuevaClaveCtrl.text.trim(),
        },
      );

      if (!mounted) return; // 👈 evita warnings

      if (res["exito"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res["mensaje"] ?? "Contraseña cambiada con éxito")),
        );
        emailCtrl.clear();
        nuevaClaveCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(res["mensaje"] ?? "Error al cambiar contraseña")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cambiar Contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            TextField(
              controller: codigoCtrl,
              decoration:
                  const InputDecoration(labelText: "Código de verificación"),
            ),
            TextField(
              controller: nuevaClaveCtrl,
              decoration: const InputDecoration(labelText: "Nueva contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _cambiarPassword,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Cambiar contraseña"),
            ),
          ],
        ),
      ),
    );
  }
}

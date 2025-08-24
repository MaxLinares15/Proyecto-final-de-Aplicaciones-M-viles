import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CambiarPasswordScreen extends StatefulWidget {
  const CambiarPasswordScreen({super.key});

  @override
  State<CambiarPasswordScreen> createState() => _CambiarPasswordScreenState();
}

class _CambiarPasswordScreenState extends State<CambiarPasswordScreen> {
  final emailCtrl = TextEditingController();
  final nuevaClaveCtrl = TextEditingController();
  bool loading = false;

  Future<void> _cambiarPassword() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.request(
        "cambiar_password.php", // 👈 revisa en la documentación de la API cuál es el endpoint correcto
        method: "POST",
        body: {
          "correo": emailCtrl.text.trim(),
          "clave": nuevaClaveCtrl.text.trim(),
        },
      );

      if (res["exito"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["mensaje"] ?? "Contraseña cambiada con éxito")),
        );
        emailCtrl.clear();
        nuevaClaveCtrl.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["mensaje"] ?? "Error al cambiar contraseña")),
        );
      }
    } catch (e) {
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

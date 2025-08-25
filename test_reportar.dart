// test_reportar.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "https://adamix.net/medioambiente";

Future<void> main() async {
  try {
    // 1️⃣ LOGIN
    final loginRes = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "correo": "as@test.com",
        "password": "123456",
      },
    );

    print("📥 Login status: ${loginRes.statusCode}");
    print("📥 Login body: ${loginRes.body}");

    if (loginRes.statusCode != 200) {
      throw Exception("Error login: ${loginRes.body}");
    }

    final loginData = jsonDecode(loginRes.body);
    final token = loginData["token"];
    if (token == null) throw Exception("⚠️ No se recibió token en login");

    print("✅ Token obtenido: $token");

    // 2️⃣ REPORTAR usando multipart/form-data
    final uri = Uri.parse("$baseUrl/reportes");
    final request = http.MultipartRequest("POST", uri);

    request.headers["Authorization"] = "Bearer $token";

    // Campos requeridos
    request.fields["titulo"] = "Prueba desde script (multipart)";
    request.fields["descripcion"] = "Reporte generado en test con multipart";
    request.fields["foto"] =
        "iVBORw0KGgoAAAANSUhEUgAAAAUA..."; // 👈 aquí pon un base64 real completo
    request.fields["latitud"] = "18.48";
    request.fields["longitud"] = "-69.91";

    print("📤 Enviando multipart con campos: ${request.fields.keys}");

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);

    print("📥 Reporte status: ${res.statusCode}");
    print("📥 Reporte body: ${res.body}");
  } catch (e) {
    print("❌ Error: $e");
  }
}

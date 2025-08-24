// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl; // https://adamix.net/medioambiente

  // Manejo del token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('$baseUrl/registro'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );
  return jsonDecode(response.body);
  }


  // ✅ Request genérico (form-urlencoded)
  static Future<Map<String, dynamic>> request(
    String endpoint, {
    String method = "GET",
    Map<String, String>? body,               // <-- cambiado: Map<String, String>?
    Map<String, String>? extraHeaders,
  }) async {
    final uri = Uri.parse("$baseUrl$endpoint");
    final token = await getToken();

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded", // <-- cambiado
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      if (extraHeaders != null) ...extraHeaders,
    };

    http.Response res;
    switch (method) {
      case "POST":
        res = await http.post(uri, headers: headers, body: body); // <-- sin jsonEncode
        break;
      case "PUT":
        res = await http.put(uri, headers: headers, body: body);  // <-- sin jsonEncode
        break;
      case "DELETE":
        res = await http.delete(uri, headers: headers);
        break;
      default:
        res = await http.get(uri, headers: headers);
    }

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    return jsonDecode(res.body);
  }

  // Login (endpoint correcto)
  static Future<Map<String, dynamic>> login(String correo, String clave) async {
    final res = await request(
      "/auth/login",
      method: "POST",
      body: {"correo": correo, "clave": clave},
    );
    if (res["exito"] == true && res["token"] != null) {
      await saveToken(res["token"]);
    }
    return res;
  }

  // Reportar daño (endpoint correcto protegido)
  static Future<Map<String, dynamic>> reportarDanio({
    required String titulo,
    required String descripcion,
    required String fotoBase64,
    required String lat,
    required String lng,
  }) async {
    return await request(
      "/reportes",
      method: "POST",
      body: {
        "titulo": titulo,
        "descripcion": descripcion,
        "foto": fotoBase64,
        "lat": lat,   // si la API pidiera latitud/longitud cámbialos aquí
        "lng": lng,
      },
    );
  }
  

  // Obtener mis reportes (GET protegido)
  static Future<Map<String, dynamic>> getMisReportes() async {
    return await request("/reportes");
  }

    // Voluntariado (endpoint público)
  static Future<Map<String, dynamic>> registrarVoluntario({
    required String nombre,
    required String correo,
    required String telefono,
    String cedula = '',
    String clave = '',

  }) async {
    return await request(
      "/voluntarios",
      method: "POST",
      body: {
        "cedula": cedula, // Valor por defecto si la cédula no es requerida
        "nombre": nombre,
        "correo": correo,
        "telefono": telefono,
      },
    );
  }

  // Servicios (endpoint público)
  static Future<Map<String, dynamic>> getServicios() async {
    return await request("/servicios");
  }


  // Endpoints públicos
  static Future<Map<String, dynamic>> getNoticias() => request("/noticias");
  static Future<Map<String, dynamic>> getAreasProtegidas() => request("/areas_protegidas");
  static Future<Map<String, dynamic>> getVideos() => request("/videos");
  static Future<Map<String, dynamic>> getMedidas() => request("/medidas");
  static Future<Map<String, dynamic>> getEquipo() => request("/equipo");
  static Future<Map<String, dynamic>> getNormativas() => request("/normativas");
}

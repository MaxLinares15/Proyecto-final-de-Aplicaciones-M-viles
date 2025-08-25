import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl;

  /// ===============================
  /// Manejo de token
  /// ===============================
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

  /// ===============================
  /// Request genérico con token
  /// ===============================
  static Future<Map<String, dynamic>> request(
    String endpoint, {
    String method = "GET",
    Map<String, String>? body,
  }) async {
    final uri = Uri.parse("$baseUrl/$endpoint");
    final token = await getToken();

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };

    http.Response res;
    switch (method) {
      case "POST":
        res = await http.post(uri, headers: headers, body: body);
        break;
      case "PUT":
        res = await http.put(uri, headers: headers, body: body);
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

    final decoded = jsonDecode(res.body);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    } else {
      return {'success': true, 'data': decoded};
    }
  }

  /// ===============================
  /// Métodos específicos de la API
  /// ===============================

  // 🔐 Login
  static Future<Map<String, dynamic>> login(
      String correo, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "correo": correo,
        "password": password,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final response = jsonDecode(res.body);
    if (response["token"] != null) {
      await saveToken(response["token"]);
    }

    return Map<String, dynamic>.from(response);
  }

  // Asegúrate de usar JSON y coincidir exactamente con lo que la API exige
  static Future<Map<String, dynamic>> registrarVoluntario({
    required String cedula,
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String telefono,
  }) async {
    final uri = Uri.parse("$baseUrl/voluntarios");

    final headers = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    final body = {
      "cedula": cedula,
      "nombre": nombre,
      "apellido": apellido,
      "correo": correo,
      "password": password,
      "telefono": telefono,
    };

    print("📤 Enviando body: $body");

    final res = await http.post(uri, headers: headers, body: body);

    print("📥 Respuesta ${res.statusCode}: ${res.body}");

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  // 📝 Registro
  static Future<Map<String, dynamic>> register({
    required String cedula,
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String telefono,
    required String matricula,
  }) async {
    final uri = Uri.parse("$baseUrl/auth/register");
    final res = await http.post(
      uri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "cedula": cedula,
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "password": password,
        "telefono": telefono,
        "matricula": matricula,
      },
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final response = jsonDecode(res.body);
    return Map<String, dynamic>.from(response);
  }

  // 📰 Noticias ambientales
  static Future<Map<String, dynamic>> getNoticias() async {
    return await request("noticias");
  }

  // 🌱 Áreas protegidas
  static Future<Map<String, dynamic>> getAreasProtegidas() async {
    return await request("areas_protegidas");
  }

  // 📜 Normativas
  static Future<Map<String, dynamic>> getNormativas() async {
    return await request("normativas");
  }

  // 🎥 Videos educativos
  static Future<Map<String, dynamic>> getVideos() async {
    return await request("videos");
  }

  // ♻️ Medidas ambientales
  static Future<Map<String, dynamic>> getMedidas() async {
    return await request("medidas");
  }


static Future<Map<String, dynamic>> reportarDanio({
  required String titulo,
  required String descripcion,
  required String fotoBase64,
  required double lat,
  required double lng,
}) async {
  final uri = Uri.parse("$baseUrl/reportes");
  final token = await getToken();

  final request = http.MultipartRequest("POST", uri);

  // ✅ Token en headers
  if (token != null && token.isNotEmpty) {
    request.headers["Authorization"] = "Bearer $token";
  }

  // ✅ Campos requeridos
  request.fields["titulo"] = titulo;
  request.fields["descripcion"] = descripcion;
  request.fields["foto"] = "data:image/jpeg;base64,$fotoBase64";
  request.fields["latitud"] = lat.toString();
  request.fields["longitud"] = lng.toString();

  print("📤 Enviando multipart con campos: ${request.fields.keys}");

  final streamedRes = await request.send();
  final res = await http.Response.fromStream(streamedRes);

  print("📥 Respuesta ${res.statusCode}: ${res.body}");

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }

  return Map<String, dynamic>.from(jsonDecode(res.body));
}

  static Future<Map<String, dynamic>> getServicios() async {
    return await request("servicios", method: "GET");
  }

  static Future<Map<String, dynamic>> getMisReportes() async {
    return await request("reportes", method: "GET");
  }

  // 👥 Equipo del ministerio
  static Future<Map<String, dynamic>> getEquipo() async {
    return await request("equipo");
  }

  /// ===============================
  /// Atajos genéricos
  /// ===============================
  static Future<Map<String, dynamic>> get(String endpoint) async {
    return await request(endpoint, method: "GET");
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, String> body) async {
    return await request(endpoint, method: "POST", body: body);
  }
}

class ApiResponse<T> {
  final bool exito;
  final String mensaje;
  final T? data;
  ApiResponse({required this.exito, required this.mensaje, this.data});
  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      ApiResponse(exito: json['exito'] == true, mensaje: json['mensaje'] ?? '', data: null);
}
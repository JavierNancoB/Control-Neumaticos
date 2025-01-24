class EstadoMovil {
  final int id;
  final String descripcion;

  EstadoMovil({required this.id, required this.descripcion});

  // Método para convertir el objeto EstadoMovil a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
    };
  }

  // Método para crear un objeto EstadoMovil desde un mapa (JSON)
  factory EstadoMovil.fromJson(Map<String, dynamic> json) {
    return EstadoMovil(
      id: json['id'],
      descripcion: json['descripcion'],
    );
  }

  // Puedes añadir más métodos según sea necesario
}

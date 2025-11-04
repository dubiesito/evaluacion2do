class Tarea {
  int? id;
  String titulo;
  String? descripcion;
  String prioridad;
  String fechaVencimiento;
  bool completada;

  Tarea({
    this.id,
    required this.titulo,
    this.descripcion,
    required this.prioridad,
    required this.fechaVencimiento,
    this.completada = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'fecha_vencimiento': fechaVencimiento,
      'completada': completada ? 1 : 0,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'],
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      prioridad: map['prioridad'],
      fechaVencimiento: map['fecha_vencimiento'],
      completada: map['completada'] == 1,
    );
  }
}
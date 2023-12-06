class adopcion {
  int id;
  int id_user;
  String nombre_persona;
  String telefono;
  String nombre;
  String meses;
  String raza;
  String comentarios;
  String url_foto;
  String fecha_registro;

  String message;
  bool status;

  adopcion(
      {this.id,
      this.id_user,
      this.nombre_persona,
      this.telefono,
      this.meses,
      this.nombre,
      this.raza,
      this.comentarios,
      this.url_foto,
      this.fecha_registro,
      this.message,
      this.status});

  factory adopcion.fromJson(Map<String, dynamic> json) {
    return adopcion(
        id: int.parse(json['id']),
        id_user: int.parse(json['id_user']),
        nombre_persona: json['nombre_persona'] as String,
        telefono: json['telefono'] as String,
        nombre: json['nombre'] as String,
        meses: json['meses'] as String,
        raza: json['raza'] as String,
        comentarios: json['comentarios'] as String,
        url_foto: json['url_foto'] as String,
        message: json['message'] as String,
        status: json['status'] as bool);
  }
}

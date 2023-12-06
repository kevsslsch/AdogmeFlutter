class user {
  int id;
  String nombre;
  String numero_telefono;
  String url_avatar;

  String message;
  bool status;

  user(
      {this.id,
      this.nombre,
      this.numero_telefono,
      this.url_avatar,
      this.message,
      this.status});

  factory user.fromJson(Map<String, dynamic> json) {
    return user(
        id: (json['id_user'] != null ? int.parse(json['id_user']) : 0),
        nombre: json['nombre'] as String,
        numero_telefono: json['numero_telefono'] as String,
        url_avatar: json['url_avatar'] as String,

        message: json['message'] as String,
        status: json['status'] as bool);
  }
}

class responseAPI {
  bool status;
  String message;
  String url_foto;

  responseAPI({this.status, this.message, this.url_foto});

  factory responseAPI.fromJson(Map<String, dynamic> json) {
    return responseAPI(
      status: json['status'] as bool,
      message: json['message'] as String,
      url_foto: json['url_foto'] as String,
    );
  }
}

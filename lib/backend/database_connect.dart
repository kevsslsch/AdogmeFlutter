import 'dart:convert';
import 'package:becadosCE/models/responseModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adopcionModel.dart';
import '../models/userModel.dart';
import '../models/responseModel.dart';

class DatabaseProvider {
  SharedPreferences preffs;
  static const VERSION = "1.0.0";

  static const ROOT = "https://aslsoft.dev/clientes/adogme/api/";
  static const ROOTREVISARTELEFONO = "revisar_telefono.php";
  static const ROOTREGISTRAR = "registro.php";
  static const ROOTLOGIN = "login.php";
  static const ROOTGETADOPCIONES = "get_adopciones.php";
  static const ROOTUPLOADFOTO = "subir_foto.php";
  static const ROOTREGISTRARADOPCION = "registro_adopcion.php";

  static Future<user> getRevisarTelefono( String numeroTelefono) async {
    var preffs = await SharedPreferences.getInstance();
    Map data = {'numeroTelefono': numeroTelefono};
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(ROOT + ROOTREVISARTELEFONO),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print("response" + response.body);
      user list = user.fromJson(json.decode(response.body));

      return list;
    } else {
      throw <user>[];
    }
  }

  static Future<user> registrar( String nombre, String numeroTelefono, String fechaNacimiento, String contrasena) async {
    var preffs = await SharedPreferences.getInstance();
    Map data = {'nombre': nombre,
                'numeroTelefono': numeroTelefono,
                'fechaNacimiento': fechaNacimiento,
                'contrasena': contrasena
              };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(ROOT + ROOTREGISTRAR),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print("response" + response.body);
      user list = user.fromJson(json.decode(response.body));

      return list;
    } else {
      throw <user>[];
    }
  }

  static Future<user> login(
      String numeroTelefono, String contrasena) async {
    var preffs = await SharedPreferences.getInstance();
    Map data = {'numeroTelefono': numeroTelefono, 'contrasena': contrasena};
    //encode Map to JSON
    print(data);
    var body = json.encode(data);
    var response = await http.post(Uri.parse(ROOT + ROOTLOGIN),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print(response.body);
      user list = user.fromJson(json.decode(response.body));

      return list;
    } else {
      throw <user>[];
    }
  }

  static Future<List<adopcion>> getAdopciones() async {

    var response = await http.get(Uri.parse(ROOT + ROOTGETADOPCIONES));

    if (response.statusCode == 200) {
      print(response.body);
      List<adopcion> listaEvidencias = parseAdopciones(json.decode(response.body));
      return listaEvidencias;
    } else {
      throw <adopcion>[];
    }
  }

  static List<adopcion> parseAdopciones(Map<String, dynamic> responseBody) {

    List<dynamic> detallesjson =  responseBody['adopciones'];
    return detallesjson.map<adopcion>((json) => adopcion.fromJson(json)).toList();
  }

  static Future<responseAPI> uploadFoto(String path) async {
    http.MultipartRequest request =
    new http.MultipartRequest("POST", Uri.parse(ROOT + ROOTUPLOADFOTO));
    http.MultipartFile multipartFile =
    await http.MultipartFile.fromPath('file', path);

    request.files.add(multipartFile);

    var headers = {"content-type": "multipart/form-data"};
    request.headers.addAll(headers);
    String responseString = "";
    var response = await request.send();
    if (response.statusCode == 200) {

      responseString = await response.stream.bytesToString();

      responseAPI responseapi = responseAPI.fromJson(json.decode(responseString));

      return responseapi;

    } else {
      throw <responseAPI>[];
    }
  }

  static Future<user> registrarAdopcion( int id_user, String nombre, String meses, String raza, String comentarios, String url_foto) async {
    var preffs = await SharedPreferences.getInstance();
    Map data = {
      'id_user': id_user,
      'nombre': nombre,
      'meses': meses,
      'raza': raza,
      'comentarios': comentarios,
      'url_foto': url_foto
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(ROOT + ROOTREGISTRARADOPCION),
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode == 200) {
      print("response" + response.body);
      user list = user.fromJson(json.decode(response.body));

      return list;
    } else {
      throw <user>[];
    }
  }

}

import 'dart:io';
import 'dart:math';

import 'package:becadosCE/widgets/analizar_raza_widget.dart';
import 'package:becadosCE/widgets/home_widget.dart';
import 'package:becadosCE/widgets/registrando_adopcion_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../application/functions.dart';
import '../backend/database_connect.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../models/userModel.dart';

class DarAdopcionWidget extends StatefulWidget {
  final user usuario;

  const DarAdopcionWidget({Key key, this.usuario}) : super(key: key);

  @override
  _DarAdopcionWidgetState createState() => _DarAdopcionWidgetState();
}

class _DarAdopcionWidgetState extends State<DarAdopcionWidget> {
  String url_foto = "";

  TextEditingController nombreController;
  TextEditingController mesesController;
  TextEditingController razaController;
  TextEditingController comentariosController;

  SharedPreferences preffs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
    mesesController = TextEditingController();
    razaController = TextEditingController();
    comentariosController = TextEditingController();
  }

  _pickFile() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        File compressedImage = await File(image.path);

        setState(() {
          _image = File(compressedImage.path);
          _guardarFoto();
        });
      }
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir
      print('Error al tomar la foto: $e');
    }
  }

  _guardarFoto() async {
    Functions.showAlertLoading(context, "Subiendo foto...");

    DatabaseProvider.uploadFoto(_image.path).then((response) {
      setState(() {
        try {
          Navigator.pop(context);

          if (response.status) {

            url_foto = response.url_foto;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnalizarRazaWidget(url_foto: url_foto)),
            );

          } else {
            Functions.showAlert(context, response.message);
          }
        } catch (e) {}
      });
    });
  }

  _guardar() async {
    preffs = await SharedPreferences.getInstance();

    if (nombreController.text.isEmpty) {
      Functions.showAlert(context, "Debes escribir un nombre");
    }else if(mesesController.text.isEmpty){
      Functions.showAlert(context, "Debes escribir un número de meses (no tiene que ser exacto)");
    }else if(url_foto.isEmpty){
      Functions.showAlert(context, "¡Ponlo guap@ y tómale una foto!");
    }else{

      DatabaseProvider.registrarAdopcion(
          widget.usuario.id,
          nombreController.text,
          mesesController.text,
          razaController.text,
          comentariosController.text,
          url_foto
      ).then((value) {
        print(value.nombre);
        if (value.status) {

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => RegistrandoAdopcionWidget(usuario: widget.usuario,)));

        }else{
          Functions.showAlert(context, value.message);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme
          .of(context)
          .background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adog me!",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    "Dar en Adopción",
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text("¿Cómo se llama?",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Escribe su nombre (opcional)',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text("¿Cuántos meses tiene?",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: TextField(
                    controller: mesesController,
                    decoration: InputDecoration(
                      labelText: 'Escribe un número',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text("Tómale una foto",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                GestureDetector(
                  onTap: () {
                    _pickFile();
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/camera.png',
                        // Path to your custom icon image
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text("¿Conoces su raza?",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: TextField(
                    controller: razaController,
                    decoration: InputDecoration(
                      labelText: 'Escribe la raza, si la conoces',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text("Comentarios opcionales",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: TextField(
                    controller: comentariosController,
                    decoration: InputDecoration(
                      labelText:
                      'Escribe un comentario relevante sobre la mascota',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    "Al continuar, se publicará la solicitud de adopción y se hará público tu nombre y teléfono para que te contacten.",
                    style: GoogleFonts.getFont('Poppins',
                        fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      _guardar();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        FlutterFlowTheme
                            .of(context)
                            .primaryColor,
                      ),
                      elevation: MaterialStateProperty.all(0),
                      // Eliminar la sombra
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(
                            16.0), // Ajusta el padding según tus necesidades
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Continuar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Desarrollado por Alumnos de 8vo Semestre\ndel Tec 2 de Ing de Sistemas',
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

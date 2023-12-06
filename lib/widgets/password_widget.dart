import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../application/functions.dart';
import '../backend/database_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/footer.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../models/userModel.dart';
import 'home_widget.dart';

class PasswordWidget extends StatefulWidget {
  final user usuario;

  const PasswordWidget({Key key, this.usuario}) : super(key: key);

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {

  SharedPreferences preffs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController contrasenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _iniciarSesion() async{
    preffs = await SharedPreferences.getInstance();

    if (contrasenaController.text.isEmpty) {
      Functions.showAlert(context, "Debes escribir tu contraseña");
    }else{

      DatabaseProvider.login(widget.usuario.numero_telefono,
          contrasenaController.text
      ).then((value) {
        print(value.nombre);
        if (value.status) {

          preffs.setString("user", widget.usuario.numero_telefono);
          preffs.setString("password", contrasenaController.text);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeWidget(usuario: value)),
          );
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
        backgroundColor: FlutterFlowTheme.of(context).background,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsetsDirectional.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Adog me!",
                              style: GoogleFonts.getFont('Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                  color: Colors.black)),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text("Hola, " + widget.usuario.nombre.trim(),
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text("Escribe tu contraseña",
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black)),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                            child: TextField(
                              controller: contrasenaController,
                              obscureText: true,
                              // Para ocultar el texto como contraseña
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
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
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                            child: ElevatedButton(
                              onPressed: () {
                                _iniciarSesion();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    FlutterFlowTheme.of(context).primaryColor),
                                elevation: MaterialStateProperty.all(0),
                                // Eliminar la sombra
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
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
                        ])))));
  }
}

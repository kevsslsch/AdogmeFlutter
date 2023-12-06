import 'dart:math';

import 'package:becadosCE/widgets/password_widget.dart';
import 'package:becadosCE/widgets/reconocimiento_widget.dart';
import 'package:becadosCE/widgets/register_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../application/functions.dart';
import '../backend/database_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/footer.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'home_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController numeroTelefonoController;
  SharedPreferences preffs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentSession();

    numeroTelefonoController = TextEditingController();
  }

  _currentSession() async {

    preffs = await SharedPreferences.getInstance();
    String usuario = preffs.getString("user");
    String password = preffs.getString("password");

    Future.delayed(Duration(seconds: 1)).then((value) {
      DatabaseProvider.login(usuario, password).then((value) {
        if (value.status) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              reverseDuration: Duration(milliseconds: 300),
              child: HomeWidget(
                usuario: value,
              ),
            ),
          );
        } else {}
      });
    });
  }

  _getTelefono() async {

    if(numeroTelefonoController.text.isEmpty){
      Functions.showAlert(context, "Debes escribir un número de teléfono");
    }else {
      preffs = await SharedPreferences.getInstance();
      DatabaseProvider.getRevisarTelefono(numeroTelefonoController.text)
          .then((value) {
        print(value.nombre);
        if (value.status) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PasswordWidget(usuario: value),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  RegisterWidget(numeroTelefono: numeroTelefonoController.text),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        }
      }).onError((error, stackTrace) {
        print(error);

        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              CupertinoAlertDialog(
                title: const Text('ERROR'),
                content:
                const Text('Error de conexión o busqueda en la base de datos'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).background,
        body: SafeArea(
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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text("Ingresa tu número de teléfono",
                            style: GoogleFonts.getFont('Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                        child: Text(
                            "Para iniciar sesión o registrarte a Adog me!",
                            style: GoogleFonts.getFont('Poppins',
                                fontSize: 15, color: Colors.black)),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: TextFormField(
                          controller: numeroTelefonoController,
                          decoration: InputDecoration(
                            labelText: '+52',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none, // Sin bordes
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          keyboardType: TextInputType.phone,
                          maxLength:
                              10, // Longitud máxima del número de teléfono
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getTelefono();
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
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                      Expanded(
                        child: Align(
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
                      ),
                    ]))));
  }
}

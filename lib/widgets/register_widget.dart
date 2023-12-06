import 'dart:math';

import 'package:becadosCE/widgets/home_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../application/functions.dart';
import '../backend/database_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/footer.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class RegisterWidget extends StatefulWidget {
  final String numeroTelefono;

  const RegisterWidget({Key key, this.numeroTelefono}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  TextEditingController nombreController;
  TextEditingController numeroTelefonoController;
  TextEditingController contrasenaController;

  SharedPreferences preffs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _dayController = TextEditingController();
  TextEditingController _monthController = TextEditingController();
  TextEditingController _yearController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dayController.text = DateFormat('dd').format(picked);
        _monthController.text = DateFormat('MM').format(picked);
        _yearController.text = DateFormat('yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();


    nombreController = TextEditingController();
    numeroTelefonoController = TextEditingController();
    contrasenaController = TextEditingController();

    numeroTelefonoController.text = widget.numeroTelefono;
  }

  _registrar() async {
    preffs = await SharedPreferences.getInstance();

    if (nombreController.text.isEmpty) {
      Functions.showAlert(context, "Debes escribir tu nombre");
    }else if(numeroTelefonoController.text.isEmpty){
      Functions.showAlert(context, "Debes escribir tu número de teléfono");
    }else if(_dayController.text.isEmpty || _monthController.text.isEmpty || _yearController.text.isEmpty){
      Functions.showAlert(context, "Selecciona tu fecha de cumpleaños");
    }else if(contrasenaController.text.isEmpty){
      Functions.showAlert(context, "Escribe tu contraseña");
    }else if(contrasenaController.text.length < 8){
      Functions.showAlert(context, "Tu contraseña debe tener mínimo 8 carácteres");
    }else{
      String fechaNacimiento = _dayController.text + "/" + _monthController.text + "/" + _yearController.text;

      DatabaseProvider.registrar(nombreController.text,
                                numeroTelefonoController.text,
                                fechaNacimiento,
                                contrasenaController.text
      ).then((value) {
        print(value.nombre);
        if (value.status) {

          preffs.setString("user", numeroTelefonoController.text);
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
                    "¡Hola!",
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
                  child: Text("¿Cómo te llamas?",
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
                      labelText: 'Escribe tu nombre',
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
                  child: Text("Teléfono celular",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
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
                    maxLength: 10, // Longitud máxima del número de teléfono
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Text("¿Cuándo naciste?",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _dayController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Día',
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _monthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Mes',
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
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Año',
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
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text("Escribe una contraseña segura",
                      style: GoogleFonts.getFont('Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
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
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      _registrar();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        FlutterFlowTheme.of(context).primaryColor,
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

import 'dart:math';

import 'package:becadosCE/widgets/dar_adoptacion.dart';
import 'package:becadosCE/widgets/password_widget.dart';
import 'package:becadosCE/widgets/register_widget.dart';
import 'package:becadosCE/widgets/youtube_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backend/database_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/footer.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../models/adopcionModel.dart';
import '../models/userModel.dart';
import 'login_widget.dart';

class HomeWidget extends StatefulWidget {
  final user usuario;

  const HomeWidget({Key key, this.usuario}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  SharedPreferences preffs;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<adopcion> listAdopciones = [];

  @override
  void initState() {
    super.initState();
    _getAdopciones();
  }

  _logOut() async{
    var preffs = await SharedPreferences.getInstance();
    preffs.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginWidget()));
  }

  _getAdopciones() {
    DatabaseProvider.getAdopciones().then((value) {
      setState(() {
        listAdopciones = value;
      });
    });
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
                        Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                            child: Text("Adog me!",
                                style: GoogleFonts.getFont('Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    color: Colors.black))),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/noavatar.jpeg',
                              // Path to your custom icon image
                              width: 80,
                              height: 80,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("Hola, " + widget.usuario.nombre.trim(),
                                      style: GoogleFonts.getFont('Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black)),
                                  Text("Bienvenido a Adog me!",
                                      style: GoogleFonts.getFont('Poppins',
                                          fontSize: 15, color: Colors.black))
                                ]),
                            Spacer(),
                            // Spacer widget to push the next widget to the right

                            // Logout icon on the right side

                            GestureDetector(
                                onTap: () {
                                 _logOut();
                                },
                                child: SizedBox(
                                  width: 50.0, // Set the width of the icon
                                  height: 50.0, // Set the height of the icon
                                  child: Icon(
                                    Icons.logout,
                                    // Replace with the desired icon
                                    size: 30.0, // Set the size of the icon
                                    color: Colors
                                        .black, // Set the color of the icon
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 0, 0),
                          child: Text("Te esperan con amor ❤️",
                              style: GoogleFonts.getFont('Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black)),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: listAdopciones.isEmpty
                                ? Container(
                              margin: EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(
                                        10, 15, 10, 0),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/ico_no_data.png",
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                .20,
                                          ),
                                        ]),
                                  ),
                                  Text(
                                    "Sin adopciones",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    "Aún no hay perritos que adoptar, pero habrá pronto.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.getFont('Poppins',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            )
                                : Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 15, 10, 0),
                                  child: Column(
                                    children: [
                                      listAdopciones.isNotEmpty
                                          ? Column(
                                        children: <Widget>[
                                          ListView.builder(
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              scrollDirection:
                                              Axis.vertical,
                                              itemCount:
                                              listAdopciones
                                                  .length,
                                              shrinkWrap: true,
                                              itemBuilder: (context,
                                                  listViewIndex) {
                                                final evento =
                                                listAdopciones[
                                                listViewIndex];

                                                return InkWell(
                                                  onTap: () {
                                                    /*
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder:
                                                            (context, animation, secondaryAnimation) =>
                                                            YoutubeWidget(),
                                                        transitionsBuilder: (context, animation,
                                                            secondaryAnimation, child) {
                                                          const begin = Offset(0.0, 1.0);
                                                          const end = Offset.zero;
                                                          const curve = Curves.easeInOut;

                                                          var tween = Tween(begin: begin, end: end)
                                                              .chain(CurveTween(curve: curve));

                                                          var offsetAnimation = animation.drive(tween);

                                                          return SlideTransition(
                                                            position: offsetAnimation,
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );*/
                                                  },
                                                  child: Card(
                                                    margin: EdgeInsets.all(10),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                    ),
                                                    elevation: 15,
                                                    shadowColor: Color(0x56EEEEEE),
                                                    // Color de sombra más gris
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.vertical(
                                                              top: Radius.circular(15.0)),
                                                          child: Image.network(
                                                            evento.url_foto,
                                                            height: 150,
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text(
                                                                'Raza: ' + evento.raza,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              Text('Nombre: ' + evento.nombre),
                                                              Text('Edad: ' + evento.meses + ' meses'),
                                                              SizedBox(height: 10),
                                                              Text('Nombre Contacto: ' + evento.nombre_persona),
                                                              Text('Teléfono Contacto: ' + evento.telefono)
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      )
                                          : Column()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])))),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Lógica para el primer botón flotante
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DarAdopcionWidget(usuario: widget.usuario),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Icon(Icons.pets),
            backgroundColor:
            FlutterFlowTheme.of(context).primaryColor, // Color de fondo del botón flotante
          ),
          SizedBox(height: 16.0), // Espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      YoutubeWidget(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Icon(Icons.play_arrow),
            backgroundColor:
            FlutterFlowTheme.of(context).primaryColor, // Color de fondo del segundo botón flotante
          ),
        ],
      ),

    );
  }
}

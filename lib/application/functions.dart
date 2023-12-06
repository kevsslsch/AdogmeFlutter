
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../models/userModel.dart';
import '../widgets/login_widget.dart';

class Functions {

  static Future<void> showAlert(BuildContext context, String text) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> closeKeyBoard() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<void> logOut (BuildContext context) async {
    var preffs = await SharedPreferences.getInstance();
    preffs.clear();

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginWidget()));
  }


  static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }

  static Future<void> showAlertLoading(BuildContext context, String text) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
                  child: new
                  SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context)
                            .primaryColor),
                      ),
                      height: 50.0,
                      width: 50.0
                  )
              ),

              Padding(
                padding: EdgeInsetsDirectional.all(20),
                child: new Text(text,
                  style: GoogleFonts.getFont('Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,),),
              ),

            ],
          ),
        );
      },
    );
  }


}

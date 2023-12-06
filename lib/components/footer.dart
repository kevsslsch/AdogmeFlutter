import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/database_connect.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class FooterWidget extends StatefulWidget {

  const FooterWidget({Key key})
      : super(key: key);

  @override
  _FooterWidgetState createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext buildContext) {

    return Container(
      width: MediaQuery.of(context).size.width,

      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Desarrollado por:\nAslSoft.dev ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: FlutterFlowTheme.of(context).primaryColor)),
              ],
            ),
          ),

          Text(
            "Versión " + DatabaseProvider.VERSION,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
                'Poppins',
                fontWeight: FontWeight.normal,
                fontSize: 13,
                color: FlutterFlowTheme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

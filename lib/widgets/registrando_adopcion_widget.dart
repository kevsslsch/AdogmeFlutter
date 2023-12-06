import 'dart:math';

import 'package:becadosCE/widgets/login_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../backend/database_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/footer.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../models/userModel.dart';
import 'home_widget.dart';

class RegistrandoAdopcionWidget extends StatefulWidget {
  final user usuario;
  const RegistrandoAdopcionWidget({Key key, this.usuario}) : super(key: key);

  @override
  _RegistrandoAdopcionWidgetState createState() => _RegistrandoAdopcionWidgetState();
}

class _RegistrandoAdopcionWidgetState extends State<RegistrandoAdopcionWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://aslsoft.dev/clientes/adogme/graficacion/registrando_adopcion_texto.html'));

    Future.delayed(Duration(seconds: 7), () {
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("¡Registrado con éxito! Ya lo puedes encontrar en la pantalla principal."),
            actions: <Widget>[
              TextButton(
                onPressed: () =>  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeWidget(usuario: widget.usuario))),
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).background,
      body: WebViewWidget(controller: controller),
    );
  }
}

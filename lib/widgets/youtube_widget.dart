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

class YoutubeWidget extends StatefulWidget {
  const YoutubeWidget({Key key}) : super(key: key);

  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<YoutubeWidget> {
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
      ..loadRequest(Uri.parse('https://aslsoft.dev/clientes/adogme/graficacion/youtube.html'));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).background,
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: controller),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            width: double.infinity, // Ocupa todo el ancho disponible
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                fixedSize: Size(200.0, 50.0), // Ancho y alto del botón
              ),
              child: Text(
                "Volver",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

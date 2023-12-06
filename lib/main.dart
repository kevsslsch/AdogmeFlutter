import 'package:becadosCE/widgets/login_widget.dart';
import 'package:becadosCE/widgets/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/userModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  ThemeMode _themeMode = ThemeMode.light;
  bool displaySplashImage = true;

  //var becado = new user(id: 290, folio_ce: 'DEV 0290', nombre: 'Kevin Solís', status: true);

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {_themeMode = mode;});

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () => setState(() => displaySplashImage = false));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adogme!',
      localizationsDelegates: [
        //FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('es', '')],
      theme: ThemeData(brightness: Brightness.light),
      themeMode: _themeMode,
      //home: HomePageWidget(usuario: becado),
      home: SplashWidget(),
    );
  }
}
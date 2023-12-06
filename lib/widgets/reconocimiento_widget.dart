import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class ReconocimientoWidget extends StatefulWidget {
  const ReconocimientoWidget({Key key}) : super(key: key);

  @override
  _ReconocimientoWidgetState createState() => _ReconocimientoWidgetState();
}

class _ReconocimientoWidgetState extends State<ReconocimientoWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController _cameraController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();

    loadModel();
    initCamera();
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
    } catch (e) {
      print('Error al cargar el modelo: $e');
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();

    if (!mounted) {
      return;
    }

    setState(() {});
  }


  Future<void> runModelOnImage(String filepath) async {
    var recognitions = await Tflite.runModelOnImage(
        path: filepath,   // required
        imageMean: 127.5,   // defaults to 117.0
        imageStd: 180,  // defaults to 1.0
        numResults: 1,    // defaults to 5
        threshold: 0.5,   // defaults to 0.1
        asynch: true      // defaults to true
    );

    print("prediccion: " + recognitions.toString());

    showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(recognitions.toString()),
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

  Future<void> captureImage() async {
    final XFile pickedFile =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      runModelOnImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).background,
      body: CameraPreview(_cameraController),
      floatingActionButton: FloatingActionButton(
        onPressed: captureImage,
        tooltip: 'Capture Image',
        child: Icon(Icons.camera),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutterar/main.dart';

class CameraApp extends StatefulWidget {
  CameraController controller;
  CameraApp(this.controller);
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    // CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return
        //Scaffold(
        //body:
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //child: Stack(children: <Widget>[
        // Container(
        //   width: 100,
        //   height: 100,
        //   color: Colors.white,
        // ),
        CameraPreview(controller);
    //]),
    //),
    //);
  }
}

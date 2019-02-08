import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterar/camera.dart';
import 'package:flutterar/draw.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String filePath;
String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
GlobalKey previewContainer = new GlobalKey();
List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  List<Offset> points = <Offset>[];
  Image _image2;
  CameraController controller =
      CameraController(cameras[0], ResolutionPreset.medium);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RepaintBoundary(
              key: previewContainer,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.2,
                child: Stack(children: <Widget>[
                  CameraApp(controller),
                  // Container(
                  //   child: GestureDetector(

                  //     child: Image.asset('assets/sunglass.png'),
                  //   ),
                  // ),
                  Container(
                    child: GestureDetector(
                      onPanUpdate: (DragUpdateDetails details) {
                        setState(() {
                          RenderBox object = context.findRenderObject();
                          Offset localPos =
                              object.globalToLocal(details.globalPosition);
                          points = List.from(points)..add(localPos);
                        });
                      },
                      onPanEnd: (DragEndDetails details) => points.add(null),
                      child: CustomPaint(
                        painter: Draw(points: points),
                        size: Size.infinite,
                      ),
                    ),
                    // width: 100,
                    // height: 100,
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   color: Colors.pinkAccent,
                    // ),
                  ),
                ]),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    elevation: 10.0,
                    color: Colors.white,
                    onPressed: () {
                      //print(points);
                      setState(() {
                        filePath = null;
                        _image2 = null;
                        points.clear();
                      });
                    },
                    child: Text("Un Draw"),
                  ),
                  RaisedButton(
                    elevation: 10.0,
                    color: Colors.white,
                    onPressed: () {
                      takePicture();
                    },
                    child: Text("Take a Picture"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: _image2 != null && filePath != null
                  ? Container(
                      width: 300.0,
                      height: 400.0,
                      //color: Colors.white,
                      child: Stack(children: <Widget>[
                        Image.file(File(filePath)),
                        _image2,
                      ]))
                  : Container(),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  takePicture() async {
    final imgDir = (await getApplicationDocumentsDirectory()).path;
    String imgPath = '$imgDir/${timestamp()}';
    await controller.takePicture(imgPath).whenComplete(() {
      setState(() {
        filePath = imgPath;
      });
    });

    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();

    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    setState(() {
      _image2 = Image.memory(pngBytes.buffer.asUint8List());
    });
    //print(pngBytes);
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    print("$directory/screenshotFR.png");
    print("you ${_image2.image}");
  }
}

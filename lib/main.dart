import 'dart:typed_data';
import 'dart:ui' as DartUI;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pen_signer_sample/signer_board_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '签字板',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '手写签名'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _boardKey = GlobalKey<SignerBoardViewState>();

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(title: Text(widget.title), centerTitle: true);
    return Scaffold(
        appBar: appBar,
        backgroundColor: Colors.grey[200],
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: OrientationBuilder(builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                var boardView =
                    SignerBoardView(key: _boardKey, penSize: 6.0, boardColor: Colors.white);
                return Container(height: 240, child: boardView);
              } else {
                return Center(
                    child: Text("请旋转手机到横屏模式使用签名",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)));
              }
            })));
  }

//  floatingActionButton: FloatingActionButton(
//  child: Text("保存"),
//  onPressed: () {
//  //_boardKey.currentState.reset();
//  _boardKey.currentState.capture().then((image) {
//  showImage(image);
//  }, onError: (error) {
//  debugPrint(error);
//  });
//  },
//  ),

  Future<Null> showImage(DartUI.Image image) async {
    var pngBytes = await image.toByteData(format: DartUI.ImageByteFormat.png);
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Please check your Signature',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 1.1),
            ),
            content: Image.memory(Uint8List.view(pngBytes.buffer)),
          );
        });
  }
}

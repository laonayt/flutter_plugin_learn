import 'package:flutter/material.dart';
import 'package:flutter_app/camera_plugin_page.dart';
import 'package:flutter_app/flutter_channel_page.dart';
import 'package:flutter_app/platform_view_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter app',
      home: CameraPage(),
    );
  }
}


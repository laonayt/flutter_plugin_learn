import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class PlatformViewPage extends StatefulWidget {
  @override
  _PlatformViewPageState createState() => _PlatformViewPageState();
}

class _PlatformViewPageState extends State<PlatformViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlatformView'),
      ),
      body: Container(
        child: _buildPlatformView(),
      ),
    );
  }

  Widget _buildPlatformView() {
    return Platform.isAndroid ?
        AndroidView(
          viewType: "webview",//对应原生端唯一表示字符串
          creationParamsCodec: StandardMessageCodec(),//参数的编码，如果有参数，这个必须要
          creationParams: <String,String>{//参数
            "url" : "http://www.baidu.com"
          },
        ):
        UiKitView(
          viewType: "webview",
          creationParamsCodec: StandardMessageCodec(),
          creationParams: <String,String>{
            "url" : "http://www.baidu.com"
          },
        );
  }
}

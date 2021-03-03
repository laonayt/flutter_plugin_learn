import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var _deviceName = '';
  int _textureId;

  static final MethodChannel _methodChannel = const MethodChannel('plugins.flutter.io/camera');
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _methodChannel.setMethodCallHandler((call) async {
//      print('_methodChannel 收到：' + call.toString());
//    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: Container(
        child: Column(
          children: [
            _buildPreview(),
            _buildInvokeView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if(_textureId == null){
      return Container();
    }
    return Container(
      width: Screen.width,
      height: 300,
      child: Texture(textureId: _textureId),
    );
  }

  Widget _buildInvokeView() {
    return Column(
      children: [
        RaisedButton(//1获取摄像头
          child: Text('availableCameras'),
          onPressed: () async {
            List replyList = await _methodChannel.invokeMethod("availableCameras");
            _deviceName = replyList[0]['name'];
          },
        ),
        RaisedButton(//2初始化
          child: Text('initialize'),
          onPressed: () async {
            Map<String, dynamic> params = {
              'cameraName': _deviceName,
              'resolutionPreset': 'high',
              'enableAudio': false,
            };
            Map reply = await _methodChannel.invokeMethod("initialize",params);
            _textureId = reply['textureId'];
            setState(() {});
          },
        ),
      ],
    );
  }
}

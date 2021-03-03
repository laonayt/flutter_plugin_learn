import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChannelPage extends StatefulWidget {
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  //字符串需和原生保持一致
  MethodChannel _methodChannel = MethodChannel("flutter/live/methodChannel");
  EventChannel _eventChannel = EventChannel("flutter/live/eventChannel");
  BasicMessageChannel _messageChannel = BasicMessageChannel("flutter/live/messageChannel", StandardMessageCodec());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //原生调用Flutter
    _methodChannel.setMethodCallHandler((call) async {
      print('_methodChannel 收到：' + call.toString());
    });

    _eventChannel.receiveBroadcastStream().listen((event) {
      print('_eventChannel 收到：' + event);
    });

    _messageChannel.setMessageHandler((message) async {
      print('_messageChannel 收到：' + message);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter/Nav交互'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('methodChannel'),
              onPressed: (){
                _methodChannel.invokeMethod("startLive",{"url" : "rtmp://192.168.101.164"});
              },
            ),
            RaisedButton(
              child: Text('messageChannel'),
              onPressed: (){
                Map msg = {"startLive":"rtmp://192.168.101.164"};
                _messageChannel.send(msg);
              },
            ),
          ],
        ),
      ),
    );
  }

}

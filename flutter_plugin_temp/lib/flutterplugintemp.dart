import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPluginTemp {
  static const MethodChannel _channel =
      const MethodChannel('flutter/methodChannel');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EventChannel _eventChannel = const EventChannel('flutter/eventChannel');

  initEvent() {
    _eventChannel.receiveBroadcastStream().listen((event) { 
      print('收到:' + event);
    },onError: (err){
      print('报错:' + err);
    },onDone: (){
      print('eventDone');
    });

  }

}

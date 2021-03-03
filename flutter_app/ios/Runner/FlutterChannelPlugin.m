//
//  FlutterChannelPlugin.m
//  Runner
//
//  Created by W E on 2020/8/10.
//

/*
不能直接这样在ios项目中写插件的回调，
因为每次运行都会更新GeneratedPluginRegistrant 这个类，
会按podfile的描述重新生成，
1、要不就统一像这样直接写
2、要不就统一按插件规范写
3、要不就在AppDelegate里边写，（这里不会重新生成）
 
1、MethodChannel 
2、EventChannel //Stream数据
3、MessageChannel
*/

#import "FlutterChannelPlugin.h"

@interface FlutterChannelPlugin()
@property (nonatomic) FlutterEventSink eventSink;
@end


@implementation FlutterChannelPlugin

//------------------------------FlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterChannelPlugin *plugin = [[FlutterChannelPlugin alloc] init];
    [plugin createMethodChannel:registrar];
    [plugin createEventChannel:registrar];
    [plugin createMessageChannel:registrar];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([call.method isEqualToString:@"startLive"]) {
      NSLog(@"Flutter MethodChannel 收到:startLive");
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

//------------------------------MethodChannel

- (void)createMethodChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
    methodChannelWithName:@"flutter/live/methodChannel"
          binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:self channel:methodChannel];
}


//------------------------------EventChannel && FlutterStreamHandler

- (void)createEventChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/live/eventChannel" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    return nil;
}


//------------------------------MessageChannel

- (void)createMessageChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterBasicMessageChannel *messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"flutter/live/messageChannel" binaryMessenger:[registrar messenger]];
    [messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSLog(@"MessageChannel 收到：%@",message);
//        NSString *method=message[@"method"];
//        if ([method isEqualToString:@"startLive"]) {
//            NSLog(@"Flutter MessageChannel 收到:startLive");
//        }
    }];
}

@end

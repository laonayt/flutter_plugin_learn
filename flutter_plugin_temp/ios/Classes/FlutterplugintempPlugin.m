#import "FlutterplugintempPlugin.h"

@implementation FlutterplugintempPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter/methodChannel"
            binaryMessenger:[registrar messenger]];

  FlutterplugintempPlugin* instance = [[FlutterplugintempPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/eventChannel" binaryMessenger:[registrar messenger]];
  [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - FlutterStreamHandler

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
//    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
//    _eventSink = events;
    events(@"dddd");
    return nil;
}


@end

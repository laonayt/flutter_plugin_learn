//
//  FLTImageStreamHandler.m
//  Runner
//
//  Created by W E on 2020/8/18.
//

#import "FLTImageStreamHandler.h"

@implementation FLTImageStreamHandler

- (FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

- (FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)events {
  _eventSink = events;
  return nil;
}
@end

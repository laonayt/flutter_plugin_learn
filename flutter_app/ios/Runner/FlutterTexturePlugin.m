//
//  FlutterTexturePlugin.m
//  Runner
//
//  Created by W E on 2020/8/12.
//

#import "FlutterTexturePlugin.h"
#import "CameraTest.h"

@interface FlutterTexturePlugin(){
    dispatch_queue_t _dispatchQueue;
}
@property(readonly, nonatomic) NSObject<FlutterTextureRegistry> *registry;
@property(strong ,nonatomic) CameraTest *cam;
@end

@implementation FlutterTexturePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterTexturePlugin *plugin = [[FlutterTexturePlugin alloc] init];
    [plugin createMethodChannel:registrar];
}

- (void)createMethodChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
    methodChannelWithName:@"plugins.flutter.io/camera"
          binaryMessenger:[registrar messenger]];
    _registry = [registrar textures];
    [registrar addMethodCallDelegate:self channel:methodChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if (_dispatchQueue == nil) {
    _dispatchQueue = dispatch_queue_create("io.flutter.camera.dispatchqueue", NULL);
  }

  // Invoke the plugin on another dispatch queue to avoid blocking the UI.
  dispatch_async(_dispatchQueue, ^{
    [self handleMethodCallAsync:call result:result];
  });
}

- (void)handleMethodCallAsync:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"initialize"]) {
        NSLog(@"call initialize");
        CameraTest *cam = [[CameraTest alloc] init];
        _cam = cam;
        
        int64_t textureId = [_registry registerTexture:cam];
        
        cam.onFrameAvailable = ^{
            [self->_registry textureFrameAvailable:textureId];
        };
        
        result(@{@"textureId" : @(textureId),});
        
        [cam startCapture];
    }
    else {
      result(FlutterMethodNotImplemented);
    }
}

@end

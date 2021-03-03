#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "FlutterChannelPlugin.h"
#import "FlutterPlatformViewPlugin.h"
#import "CameraPlugin.h"
#import "FlutterTexturePlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
  //1
//  [FlutterChannelPlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterChannelPlugin"]];
  //2
//  [FlutterPlatformViewPlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterPlatformViewPlugin"]];
  //3
//  [CameraPlugin registerWithRegistrar:[self registrarForPlugin:@"CameraPlugin"]];
    
  //4
  [FlutterTexturePlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterTexturePlugin"]];
    
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

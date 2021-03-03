//
//  FlutterPlatformViewPlugin.h
//  Runner
//
//  Created by W E on 2020/8/11.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

//1、Plugin 声明
@interface FlutterPlatformViewPlugin : NSObject<FlutterPlugin>

@end

//2、PlatformViewFactory 声明
@interface IOSFlutterPlatformViewFactory : NSObject <FlutterPlatformViewFactory>

@end

//3、PlatformView 声明
@interface IOSFlutterPlatformView : NSObject<FlutterPlatformView>
@property(nonatomic,strong) WKWebView * webView;
@property(nonatomic,copy) NSString * urlStr;
@end



NS_ASSUME_NONNULL_END

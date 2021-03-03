//
//  FlutterPlatformViewPlugin.m
//  Runner
//
//  Created by W E on 2020/8/11.
//

#import "FlutterPlatformViewPlugin.h"

@implementation FlutterPlatformViewPlugin

//1、plugin默认注册方法 遵循FlutterPlugin协议
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"webview"];
}

@end

//-----------------------------------------

//2、对应的视图工厂实现类，遵循FlutterPlatformViewFactory协议
@implementation IOSFlutterPlatformViewFactory

/**
 * 返回platformview实现类
 *@param frame 视图的大小
 *@param viewId 视图的唯一表示id
 *@param args 从flutter  creationParams 传回的参数
 *
 */
- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    NSLog(@"创建PlatformView %@",args);
    //这里可以解析args参数，根据参数进行响应的操作
    IOSFlutterPlatformView *view = [[IOSFlutterPlatformView alloc]init];
    view.urlStr = args[@"url"];
    return view;
}

//如果需要使用args传参到ios，需要实现这个方法，返回协议。否则会失败。
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
@end

//-----------------------------------------

//3、创建PlatformView实现类 遵循FlutterPlatformView
@implementation IOSFlutterPlatformView

- (nonnull UIView *)view {
    return [self webView];
}

- (WKWebView *)webView{
    if(_webView == nil){
        WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
        NSURL *url = [NSURL URLWithString:_urlStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
    }

    return _webView;
}

@end

/*
 4、在info.plist中加入下面的 (关键步骤)
 <key>io.flutter.embedded_views_preview</key>
 <true/>
 */

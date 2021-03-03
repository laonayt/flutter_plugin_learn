# Flutter Plugin 练习
### 准备
1、nav端（ios、android）调试原生实现。
2、flutter_app(一个), 调试插件。
3、flutter_plugin(一个), 写插件。
### 三种Channel
BasicMessageChannel：用于传递字符串和半结构化的信息
MethodChannel：用于传递方法调用（method invocation）
EventChannel：用于数据流（event streams）的通信
![BinaryMessage.png](https://upload-images.jianshu.io/upload_images/2166188-c318a5cca08f9336.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### Flutter端对三种Channel的书写
1、定义
```
//字符串需和原生保持一致
  MethodChannel _methodChannel = MethodChannel("flutter/live/methodChannel");
  EventChannel _eventChannel = EventChannel("flutter/live/eventChannel");
  BasicMessageChannel _messageChannel = BasicMessageChannel("flutter/live/messageChannel", StandardMessageCodec());
```
2、原生调用Flutter
```
_methodChannel.setMethodCallHandler((call) async {
      print('_methodChannel 收到：' + call.toString());
    });
_eventChannel.receiveBroadcastStream().listen((event) {
      print('_eventChannel 收到：' + event);
    });
_messageChannel.setMessageHandler((message) async {
      print('_messageChannel 收到：' + message);
    });
```
3、Flutter调用原生
```
_methodChannel.invokeMethod("startLive",{"url" : "rtmp://192.168.101.164"});

Map msg = {"startLive":"rtmp://192.168.101.164"};
                _messageChannel.send(msg);
```
### 原生端实现书写
两种方案
1、创建flutter plugin项目。
* 1.1 上传https://pub.flutter-io.cn/ 或github，在Flutter项目中引用
```
dio: ^3.0.6
```

* 1.2  本地引用
```
flutter_ijkplayer:
    path:
      plugins/flutter_ijkplayer
```

2、直接在Flutter项目文件夹下的iOS文件夹和Android文件夹中写实现逻辑，所以这种方案只能在本项目使用。
#### iOS端对三种Channel的书写

##### 1、创建
```
- (void)createMethodChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* methodChannel = [FlutterMethodChannel
    methodChannelWithName:@"flutter/live/methodChannel"
          binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:self channel:methodChannel];
}
```
```
- (void)createEventChannel:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"flutter/live/eventChannel" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:self];
}
```
```
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
```
##### 2、监听回调
1、MethodChannel
```
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

  if ([call.method isEqualToString:@"startLive"]) {
      NSLog(@"Flutter MethodChannel 收到:startLive");
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}
```
2、EventChannel，通过绑定FlutterEventSink，让eventSink来发送消息
```
@property (nonatomic) FlutterEventSink eventSink;
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _eventSink = events;
    return nil;
}
```
3、BasicMessageChannel 创建的时候绑定

##### 注意事项：

如果直接在Flutter项目中直接写plugin，每次运行都会更新GeneratedPluginRegistrant这个类，是按podfile的描述重新生成，**所以不要在GeneratedPluginRegistrant里边写。**

1、可以直接在AppDelegate里写

2、可以封装FlutterChannelPlugin工具类，在AppDelegate入口函数调用
```
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  
  [FlutterChannelPlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterChannelPlugin"]];
  
}
```
* 2.1、FlutterChannelPlugin需遵循代理（FlutterPlugin,FlutterStreamHandler）

* 2.2、FlutterChannelPlugin需实现FlutterPlugin代理的类方法，作为入口
```
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterChannelPlugin *plugin = [[FlutterChannelPlugin alloc] init];
    [plugin createMethodChannel:registrar];
    [plugin createEventChannel:registrar];
    [plugin createMessageChannel:registrar];
}
```

3、如果需要跳转原生页面则需拿到当前控制器
可通过下面方法实现
```
@property(strong, nonatomic) UIViewController *viewController;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_rtmp_plugin"
            binaryMessenger:[registrar messenger]];

  UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;

  FlutterRtmpPlugin* instance = [[FlutterRtmpPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
  self = [super init];
  if (self) {
    self.viewController = viewController;
  }
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"startLive"]) {
      NSDictionary * dict = call.arguments;
      NSLog(@"流地址是 %@",dict[@"url"]);

      LFViewController *liveVC = [[LFViewController alloc] init];
      liveVC.liveUrl = dict[@"url"];
      liveVC.modalPresentationStyle = UIModalPresentationFullScreen;
      [self.viewController presentViewController:liveVC animated:YES completion:nil];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}
```

#### Android端的书写
MethodChannel, 另外两种Channel参照iOS，两者类似

1、入口函数中创建MethodChannel
```
 public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutterplugintemp");
    channel.setMethodCallHandler(this);
  }
```
2、遵循两个协议 
```
implements FlutterPlugin, MethodCallHandler 
``` 
3、实现协议方法，在方法中写代码实现。
```
public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(call.method.equals("startLive")){
      Intent intent = new Intent(context,LivingActivity.class);
      String url = call.argument("url");
      intent.putExtra("url",url);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
      context.startActivity(intent);

    } else {
      result.notImplemented();
    }
```
##### 注意事项
flutter 1.12版本之前的入口函数是
```
public static void registerWith(Registrar registrar) {
```
flutter 1.12版本以后是
```
public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
```
**若果写错会收不到Flutter的方法回调**

2、若果要跳转原生页面则需要拿到app的当前context或activity
可通过这种写法获取
```
//
private Context context;

public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    FlutterRtmpPlugin plugin = new FlutterRtmpPlugin();
    plugin.context = flutterPluginBinding.getApplicationContext();
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_rtmp_plugin");
    channel.setMethodCallHandler(plugin);
  }
```
```
public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if(call.method.equals("startLive")){
      Intent intent = new Intent(context,LivingActivity.class);
      String url = call.argument("url");
      intent.putExtra("url",url);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK );
      context.startActivity(intent);

    } else {
      result.notImplemented();
    }
  }
```

#### 总结：
以上是plugin的基本使用，要想应付各种复杂的场景还需多参考google官方插件源码，来汲取养分。
比如 [camera](https://pub.flutter-io.cn/packages/camera)


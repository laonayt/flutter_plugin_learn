package com.flutter_app;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //将自己写的插件注册到Flutter，
        // GeneratedPluginRegistrant是dartTool自动生成的，写在那里会被覆盖掉
        getFlutterEngine().getPlugins().add(new FlutterChannelPlugin());
        getFlutterEngine().getPlugins().add(new FlutterPlatformViewPlugin());
    }
}

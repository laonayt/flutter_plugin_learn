package com.flutter_app;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public class FlutterChannelPlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        //1
        MethodChannel methodChannel = new MethodChannel(
                binding.getBinaryMessenger(),
                "flutter/live/methodChannel");
        methodChannel.setMethodCallHandler(new FlutterMethodChannel());

        //2
        EventChannel eventChannel = new EventChannel(
                binding.getBinaryMessenger(),
                "flutter/live/eventChannel");
        eventChannel.setStreamHandler(new FlutterStreamChannel());

        //3
        BasicMessageChannel messageChannel = new BasicMessageChannel(
                binding.getBinaryMessenger(),
                "flutter/live/messageChannel",
                new StandardMessageCodec()
        );
        messageChannel.setMessageHandler(new FlutterMessageChannel());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    //MethodChannel 协议实现部分
    public class FlutterMethodChannel implements MethodChannel.MethodCallHandler {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            Log.e("FlutterMethodChannel",call.toString());
        }
    }

    //EventChannel 协议实现部分
    public class FlutterStreamChannel implements EventChannel.StreamHandler {
        @Override
        public void onListen(Object arguments, EventChannel.EventSink events) {

        }

        @Override
        public void onCancel(Object arguments) {

        }
    }

    //MessageChannel 协议实现部分
    public  class FlutterMessageChannel implements BasicMessageChannel.MessageHandler {
        @Override
        public void onMessage(@Nullable Object message, @NonNull BasicMessageChannel.Reply reply) {
            Log.e("FlutterMessageChannel",message.toString());
        }
    }
}

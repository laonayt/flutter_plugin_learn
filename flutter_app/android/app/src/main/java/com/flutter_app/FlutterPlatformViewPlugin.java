package com.flutter_app;

import android.content.Context;
import android.view.View;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import io.flutter.plugin.platform.PlatformViewRegistry;

//implements和extends的区别是什么？

public class FlutterPlatformViewPlugin implements FlutterPlugin {

    //1、注册到flutter engine
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        PlatformViewRegistry platformViewRegistry = binding.getPlatformViewRegistry();
        platformViewRegistry.registerViewFactory("webview",new AndroidPlatformViewFactory());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    //2、实现工厂类
    public class AndroidPlatformViewFactory extends PlatformViewFactory {

        public AndroidPlatformViewFactory() {
            super(StandardMessageCodec.INSTANCE);
        }

        /**
         * 创建PlatformView
         * @param context 上下文
         * @param viewId 视图的id
         * @param args flutter端传回的参数
         * @return 返回一个PlatformView的实现类
         */
        @Override
        public PlatformView create(Context context, int viewId, Object args) {
            Map<String,String> params = (Map<String,String>)args;
            Log.e("PlatformView",params.get("url"));
            return new AndroidPlatformView(context, params.get("url"));
        }
    }

    //3、实现PlatformView接口，
    public class AndroidPlatformView implements PlatformView {
        private WebView webView;
        private Context context;

        AndroidPlatformView(Context context, String url) {
            this.context = context;

            webView = new WebView(context);
            webView.setWebViewClient(new WebViewClient(){
                @Override
                public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                    return true;
                }
            });
            WebSettings settings = webView.getSettings();
            settings.setJavaScriptEnabled(true);
            webView.loadUrl("https://www.baidu.com");
        }

        @Override
        public View getView() {
            //这个方法会被频繁的调用，所以不应该在这里面直接new 一个原生视图；会导致滑动事件出问题。
            return webView;
        }

        @Override
        public void dispose() {
            webView.destroy();
        }
    }
}

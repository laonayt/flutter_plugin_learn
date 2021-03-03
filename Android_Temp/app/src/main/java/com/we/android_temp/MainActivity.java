package com.we.android_temp;



import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends Activity {
    int index = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String[] permissionList = new String[]{
                Manifest.permission.CAMERA,
                Manifest.permission.RECORD_AUDIO,
                Manifest.permission.WAKE_LOCK,
        };
        ActivityCompat.requestPermissions(this,permissionList,1);

        Button sendBtn = findViewById(R.id.send_btn);
        sendBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this,LivingActivity.class);
                intent.putExtra("url","rtmp://192.168.101.164/rtmplive/test");
                startActivity(intent);


//                EventBus.getDefault().post("你试试:" + index);
//                index++;
            }
        });

//        Runnable runnable = new Runnable() {
//            @Override
//            public void run() {
//                Intent intent = new Intent(MainActivity.this,LivingActivity.class);
//                intent.putExtra("url","rtmp://192.168.2.125");
//                startActivity(intent);
//                finish();
//            }
//        };
//
//        Handler handler = new Handler();
//        handler.postDelayed(runnable,2000);
    }
}
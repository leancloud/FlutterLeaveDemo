package com.example.flutterapplc;

import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.vivo.push.PushClient;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        String regId = PushClient.getInstance(MainActivity.this).getRegId();
        Log.d("regid"," regId= " + regId);
    }
}

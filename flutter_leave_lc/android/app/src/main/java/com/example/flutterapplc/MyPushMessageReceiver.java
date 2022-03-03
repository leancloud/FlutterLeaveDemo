package com.example.flutterapplc;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.vivo.push.model.UnvarnishedMessage;

import java.util.logging.Logger;

import cn.leancloud.LCVIVOPushMessageReceiver;

public class MyPushMessageReceiver extends LCVIVOPushMessageReceiver {
    private static final Logger logger = Logger.getLogger(MyPushMessageReceiver.class.getSimpleName());

    @Override
    public void onTransmissionMessage(Context context, UnvarnishedMessage unvarnishedMessage) {
        super.onTransmissionMessage(context, unvarnishedMessage);
        Toast.makeText(context, " 收到透传通知： " + unvarnishedMessage.getMessage(),
                Toast.LENGTH_LONG).show();
        Log.d("PushMessageReceiver", " onTransmissionMessage= "
                + unvarnishedMessage.getMessage());
    }
}

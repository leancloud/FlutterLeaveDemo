package com.example.flutterapplc;

import cn.leancloud.LCException;
import cn.leancloud.LCInstallation;
import cn.leancloud.LCLogger;
import cn.leancloud.LCObject;
import cn.leancloud.LeanCloud;
import cn.leancloud.callback.LCCallback;
import cn.leancloud.vivo.LCMixPushManager;
import io.flutter.app.FlutterApplication;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;

public class MyApp extends FlutterApplication {
    private static final String LC_APP_ID = "eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz";
    private static final String LC_APP_KEY = "G59fl4C1uLIQVR4BIiMjxnM3";
    private static final String LC_SERVER_URL = "https://elawfuk8.lc-cn-n1-shared.com";
    //      private static final String LC_APP_ID = "Gvv2k8PugDTmYOCfuK8tiWd8-gzGzoHsz";
//  private static final String LC_APP_KEY = "dpwAo94n81jPsHVxaWwdxJVu";
//  private static final String LC_SERVER_URL = "https://gvv2k8pu.lc-cn-n1-shared.com";
    @Override
    public void onCreate() {
        super.onCreate();
        LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
        LeanCloud.initialize(this, LC_APP_ID, LC_APP_KEY, LC_SERVER_URL);
        System.out.println("打印 initialize = ：" + "initialize" );
        LCMixPushManager.registerVIVOPush(this);
        LCMixPushManager.turnOnVIVOPush(new LCCallback<Boolean>() {
            @Override
            protected void internalDone0(Boolean aBoolean, LCException e) {
                if (null != e) {
                    System.out.println("failed to turn on VIVO push. cause:");
                    e.printStackTrace();
                } else {
                    System.out.println("succeed to turn on VIVO push.");
                }
            }
        });
        LCInstallation.getCurrentInstallation().saveInBackground().subscribe(new Observer<LCObject>() {
            @Override
            public void onSubscribe(Disposable d) {
            }
            @Override
            public void onNext(LCObject avObject) {
                // 关联 installationId 到用户表等操作。
                String installationId = LCInstallation.getCurrentInstallation().getInstallationId();
                System.out.println("保存成功：" + installationId );
            }
            @Override
            public void onError(Throwable e) {
                System.out.println("保存失败，错误信息：" + e.getMessage());
            }
            @Override
            public void onComplete() {
            }
        });
        String installationId = LCInstallation.getCurrentInstallation().getInstallationId();
        System.out.println("打印 installationId = ：" + installationId );
    }
}

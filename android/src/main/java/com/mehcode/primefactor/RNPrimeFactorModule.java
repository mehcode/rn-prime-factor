package com.mehcode.primefactor;

import android.bluetooth.BluetoothAdapter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings.Secure;

import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class RNPrimeFactorModule extends ReactContextBaseJavaModule {
    static {
        System.loadLibrary("pf_jni");
    }

    public RNPrimeFactorModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNPrimeFactor";
    }

    private native long getFactorJNI(long pq);

    @ReactMethod
    public void findFactors(String pqHexStr, Promise promise) {
        try {
            long pq = Long.parseLong(pqHexStr, 16);
            long p = getFactorJNI(pq);
            long q = pq / p;

            if (p > q) {
                long tmp = p;
                p = q;
                q = tmp;
            }

            WritableArray arr = new WritableArray();
            arr.pushString(p.toString(16));
            arr.pushString(q.toString(16));

            promise.resolve(arr);
        } catch (Exception e) {
            promise.reject("ERR", e);
        }
    }
}

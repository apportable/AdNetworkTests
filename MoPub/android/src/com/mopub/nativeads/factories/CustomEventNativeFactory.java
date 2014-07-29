package com.mopub.nativeads.factories;

import com.mopub.nativeads.CustomEventNative;
import com.mopub.nativeads.MoPubCustomEventNative;

import java.lang.reflect.Constructor;

public class CustomEventNativeFactory {
    protected static CustomEventNativeFactory instance = new CustomEventNativeFactory();

    public static CustomEventNative create(final String className) throws Exception {
        if (className != null) {
            final Class<? extends CustomEventNative> nativeClass = Class.forName(className)
                    .asSubclass(CustomEventNative.class);
            return instance.internalCreate(nativeClass);
        } else {
            return new MoPubCustomEventNative();
        }
    }

    @Deprecated // for testing
    public static void setInstance(final CustomEventNativeFactory customEventNativeFactory) {
        instance = customEventNativeFactory;
    }

    protected CustomEventNative internalCreate(final Class<? extends CustomEventNative> nativeClass) throws Exception {
        final Constructor<?> nativeConstructor = nativeClass.getDeclaredConstructor((Class[]) null);
        nativeConstructor.setAccessible(true);
        return (CustomEventNative) nativeConstructor.newInstance();
    }
}

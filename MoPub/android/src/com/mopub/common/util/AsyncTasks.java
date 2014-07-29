package com.mopub.common.util;

import android.os.AsyncTask;
import android.os.Looper;

import java.util.concurrent.Executor;

import static com.mopub.common.util.Reflection.MethodBuilder;
import static com.mopub.common.util.VersionCode.ICE_CREAM_SANDWICH;
import static com.mopub.common.util.VersionCode.currentApiLevel;

public class AsyncTasks {
    /**
     * Starting with ICS, default AsyncTask#execute behavior runs the tasks serially. This method
     * attempts to force these AsyncTasks to run in parallel with a ThreadPoolExecutor, if possible.
     */
    public static <P> void safeExecuteOnExecutor(AsyncTask<P, ?, ?> asyncTask, P... params) throws IllegalArgumentException, IllegalStateException {
        if (asyncTask == null) {
            throw new IllegalArgumentException("Unable to execute null AsyncTask.");
        }

        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("AsyncTask must be executed on the main thread");
        }

        if (currentApiLevel().isAtLeast(ICE_CREAM_SANDWICH)) {
            try {
                Executor threadPoolExecutor = (Executor) AsyncTask.class.getField("THREAD_POOL_EXECUTOR").get(AsyncTask.class);

                new MethodBuilder(asyncTask, "executeOnExecutor")
                        .addParam(Executor.class, threadPoolExecutor)
                        .addParam(Object[].class, params)
                        .execute();
            } catch (Exception e) {
                asyncTask.execute(params);
            }
        } else {
            asyncTask.execute(params);
        }
    }
}

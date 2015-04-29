
Apportable documentation:
------------------------

http://docs.apportable.com/sample-apps.html#adnetworktests

## SuperSonicAds
### SuperSonic AndroidManifest.xml Requirements
Include [/adnetworktests.approj/assets/SuperSonic/application_manifest_extras.xml](/adnetworktests.approj/assets/SuperSonic/application_manifest_extras.xml) and related [/adnetworktests.approj/configuration.json](/adnetworktests.approj/configuration.json) setting.

### Using SuperSonicAds with Proguard
Add to `proguard-project.txt`:
```
-keepclassmembers class com.supersonicads.sdk.controller.SupersonicWebView$JSInterface {
    public *;
}
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
```

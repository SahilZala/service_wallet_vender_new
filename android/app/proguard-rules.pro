-keepclassmembers class * {
@android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*
-keep class androidx.lifecycle.** { *; }
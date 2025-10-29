# Supabase SDK
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# JSON Serialization
-keepclassmembers class * {
    @com.google.gson.ann# Supabase SDK
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# JSON Serialization (Gson / kotlinx)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# WebView (android.webkit)
-keep class android.webkit.** { *; }
-dontwarn android.webkit.**

# WebView internal Chromium (penting supaya tidak strip)
-keep class org.chromium.** { *; }
-dontwarn org.chromium.**

# Keep JavaScriptInterface (kalau ada)
-keepclassmembers class * {
   @android.webkit.JavascriptInterface <methods>;
}

# Jangan optimize WebView
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(...);
}
-keepclassmembers class * extends android.webkit.WebChromeClient {
    public void *(...);
}
otations.SerializedName <fields>;
}

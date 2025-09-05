# Supabase SDK
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# JSON Serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

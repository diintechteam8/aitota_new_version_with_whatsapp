#########################################################
# Flutter / Dart
#########################################################
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

#########################################################
# Firebase / Google Play Services
#########################################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

#########################################################
# Cashfree SDK
#########################################################
-keep class com.cashfree.pg.** { *; }
-dontwarn com.cashfree.pg.**

#########################################################
# Android System APIs (Contacts, Call Logs, Telephony, etc.)
#########################################################
-keep class android.provider.** { *; }
-dontwarn android.provider.**

#########################################################
# Gson / Retrofit / OkHttp / JSON
#########################################################
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**
-keepattributes Signature
-keepattributes *Annotation*

# Keep your own models (important for Gson/Retrofit)
-keep class com.diin.aitota_business.model.** { *; }

#########################################################
# Kotlin / Coroutines
#########################################################
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**
-keepclassmembers class kotlinx.coroutines.** { *; }

#########################################################
# Multidex Support
#########################################################
-keep class androidx.multidex.** { *; }
-dontwarn androidx.multidex.**

#########################################################
# Reflection / Annotations
#########################################################
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes SourceFile,LineNumberTable
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations
-keepattributes RuntimeVisibleTypeAnnotations
-keepattributes RuntimeInvisibleTypeAnnotations
-keepattributes Signature
-keepattributes *Annotation*


# قواعد ProGuard لتطبيق الملاحظات
# تحمي الكود من التشويش والاختراق العكسي

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Hive
-keep class * extends hive.HiveAdapter { *; }
-keep class **$**Adapter { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# المصادقة البيومترية
-keep class androidx.biometric.** { *; }

# الإبقاء على معلومات الأخطاء
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# منع تحذيرات
-dontwarn io.flutter.embedding.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Flutter ProGuard Rules
# Add project specific ProGuard rules here.

# Keep Flutter engine classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Keep plugin classes
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }

# Keep shared_preferences
-keep class androidx.datastore.preferences.** { *; }
-keep class androidx.datastore.** { *; }

# Keep URL launcher
-keep class androidx.browser.** { *; }

# Keep share functionality
-keep class androidx.core.content.** { *; }

# Keep confetti animations
-keep class com.jogamp.** { *; }

# Keep app specific classes
-keep class com.sorteoexpress.app.** { *; }

# Keep model classes
-keep class * extends java.lang.Object {
    public <fields>;
    public <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep serialization
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep reflection
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

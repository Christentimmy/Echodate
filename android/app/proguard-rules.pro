# Keep FirebaseInstanceId class
-keep class com.google.firebase.iid.FirebaseInstanceId { *; }

# Keep the ML Kit Text recognizer classes
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.firebase.iid.FirebaseInstanceId
# Amplify / Google Crypto Tink rules
-keepattributes *Annotation*
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
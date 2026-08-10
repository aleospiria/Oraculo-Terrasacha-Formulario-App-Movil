# Amplify / Google Crypto Tink rules
-keepattributes *Annotation*
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }

# vosk_flutter_service usa JNA para llamar a la librería nativa de Vosk vía
# reflexión; sin estas reglas, R8 la ofusca/elimina y la transcripción offline
# falla en runtime solo en builds de release (minifyEnabled true).
-keep class com.sun.jna.* { *; }
-keepclassmembers class * extends com.sun.jna.* { public *; }
# JNA hace referencia opcional a java.awt.*/Swing (solo para su integración
# con AWT en escritorio); esas clases no existen en Android y esas rutas de
# código nunca se ejecutan ahí, pero R8 falla el build si no se le dice que
# las ignore explícitamente.
-dontwarn com.sun.jna.**
-dontwarn java.awt.**
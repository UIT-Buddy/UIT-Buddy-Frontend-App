# ProGuard rules for release build minification (R8)

# CometChat SDK classes
-keep class com.cometchat.** { *; }
-dontwarn com.cometchat.**

# Ignore missing Tika and XML classes from libraries
-keep class org.apache.tika.** { *; }
-dontwarn org.apache.tika.**
-dontwarn javax.xml.stream.**

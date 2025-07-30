# Razorpay SDK - Prevent stripping of required classes
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }

# Keep annotation-related classes
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
 
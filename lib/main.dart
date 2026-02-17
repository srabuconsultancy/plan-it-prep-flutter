import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as sc;
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// import 'package:wakelock_plus/wakelock_plus.dart';

// Assuming 'core.dart' exports necessary files like services, controllers, models, routes, constants, widgets, etc.
import 'core.dart';

// Make firebaseOptions accessible globally, especially for the background handler
FirebaseOptions? firebaseOptions;

Future<void> main() async {
  // --- Ensure Flutter binding is initialized (Correct) ---
  WidgetsFlutterBinding.ensureInitialized();

  // Set your stripe publishable key
  Stripe.publishableKey = 'pk_test_51SBCMIBoy1so7bjrejudVy4BMKZieVFBwxUoZNm78hi2ea7fI53mTEpMgsTmszQ4ufvNruKabXCp9k2dQ70CgcV400ryVrNhx8';
  await Stripe.instance.applySettings();

  await Firebase.initializeApp();

  // --- Initialize GetStorage (Correct) ---
  await GetStorage.init();

  // --- Set time dilation if needed for debugging animations ---
  // sc.timeDilation = 2.0; // Keep if needed, otherwise comment out

  // --- Define Firebase Options ---
  // Moved definition here to be available for both initServices and background handler
  firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyC8J3cSINZ5nWhbkQXV4u7VsOKmdoSgHTg", // Replace with your actual key if needed
    appId: Platform.isAndroid
        ? "1:968524122508:android:f5c9525587fcc377e86ea9" // Replace with your actual App ID
        : "1:968524122508:ios:7f81065c271ba05ce86ea9", // Replace with your actual App ID
    messagingSenderId: "968524122508", // Replace with your actual Sender ID
    projectId: "dietitian-61a26", // Replace with your actual Project ID
  );

  // --- Initialize Firebase and other services ---
  // Note: Firebase is initialized *inside* initServices now
  await initServices();

  // --- Setup background message handler ---
  // Needs to be setup *after* Firebase options are defined but *before* runApp
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // --- Run the app ---
  runApp(const MyApp());
}

// --- Background Message Handler ---
@pragma('vm:entry-point') // Ensure this annotation is present for background execution
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // --- Initialize Firebase for the background isolate (using default instance) ---
  // IMPORTANT: Ensure firebaseOptions is accessible here
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: firebaseOptions);
  }
  await setupFlutterNotifications();
  showFlutterNotification(message);
  //print('Handling a background message ${message.messageId}');
}

// --- Notification Setup (largely unchanged) ---
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background', // Ensure 'launch_background.png' (or .xml) exists in android/app/src/main/res/drawable
        ),
      ),
    );
  }
}

// --- Service Initialization ---
Future<void> initServices() async {
  // --- Initialize Firebase (using default instance) ---
  // Moved this earlier, before Get.put calls that might depend on Firebase
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: firebaseOptions);
  }

  // --- Configure EasyLoading ---
  configLoading();

  // --- Initialize GetX Services and Controllers ---
  Get.put(RootService(), permanent: true);
  Get.put(UserService(), permanent: true);
  Get.put(DashboardService(), permanent: true);
  Get.put(UserController(), permanent: true);
  Get.put(PackageService(), permanent: true);
  Get.put(PackageController(), permanent: true);
  Get.put(DashboardController(), permanent: true);
  Get.put(MealPlanService(), permanent: true);
  Get.put(RootController(), permanent: true);
  Get.put(MealPlanController(), permanent: true);

  // --- Setup foreground notifications ---
  // Called after Firebase init and GetX setup
  setupFlutterNotifications();
}

// --- EasyLoading Configuration (unchanged) ---
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.transparent
    ..indicatorWidget = Container(
      width: (Get.width ?? 300) / 4.5, // Added null check for Get.width
      height: (Get.width ?? 300) / 4.5, // Added null check for Get.width
      // Use a background color that contrasts if loader is hard to see
      decoration: BoxDecoration(
         color: Colors.black.withOpacity(0.1), // Example background
         borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Lottie.asset(
        'assets/lottie/loader.json',
      ),
    ) //.cornerRadius(10) // .cornerRadius seems specific to a package like velocity_x, using BoxDecoration instead
    ..maskType = EasyLoadingMaskType.none
    ..maskColor = Colors.transparent
    ..userInteractions = true // Be cautious with 'true', might block interaction needed during loading
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[];
}


// --- Main App Widget (Stateful) ---
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // --- Finding controllers (Correct) ---
  // Ensure controllers are put before MyApp runs if finding them here
  UserController authController = Get.find();
  RootController rootController = Get.find();

  late String initialRoute;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // --- Initialization logic (Correct) ---
  initialize() async {
      try {
    await rootController.getAppConfig();
    initialRoute = await authController.checkIfAuthenticated();
  } catch (e, s) {
    // Log the error for debugging
    print("Initialization error: $e");
    print(s);
    initialRoute = Routes.register; // fallback route
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    // WakelockPlus.enable(); // Uncomment if needed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    Animate.restartOnHotReload = true;

    // --- Loading State (Correct) ---
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            // --- Ensure logo asset is valid ---
            child: Image.asset(
              'assets/images/logo.jpg', // Verify path and pubspec.yaml declaration
              width: 150,
            ),
          ),
        ),
      );
    }

    // --- Main App Build (Correct) ---
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 400),
        getPages: AppPages.routes,
        initialRoute: initialRoute,
        locale: Locale(GetStorage().read("language_code") ?? "en"),
        fallbackLocale: const Locale("en"),
        title: appName, // Ensure appName is defined globally or imported
        themeMode: ThemeMode.light,
        theme: appTheme(Brightness.light), // Ensure appTheme is defined
        builder: EasyLoading.init(
          builder: (context, child) {
            return ToastificationConfigProvider(
              config: const ToastificationConfig(
                alignment: Alignment.topCenter,
                animationDuration: Duration(milliseconds: 500),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }

  // --- Theme Definition (Unchanged, assuming it works) ---
  ThemeData appTheme(brightness) {
    var baseTheme = ThemeData(
      fontFamily: 'Poppins',
      primaryColor: glLightPrimaryColor,
      highlightColor: glAccentColor,
      brightness: Brightness.light,
      dividerColor: glLightDividerColor,
      shadowColor: glLightBoxShadowColor,
      hintColor: glLightHintColor,
      iconTheme: IconThemeData(color: glLightIconColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: glLightButtonBGColor,
          foregroundColor: glLightButtonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          textStyle: GoogleFonts.poppins().copyWith(
              fontSize: buttonTextFontSize,
              color: glLightButtonTextColor,
              fontWeight: FontWeight.w400),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins().copyWith(
            fontSize: titleLarge,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
        titleMedium: GoogleFonts.poppins().copyWith(
            fontSize: titleMedium,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
        titleSmall: GoogleFonts.poppins().copyWith(
            fontSize: titleSmall,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
        headlineSmall: GoogleFonts.poppins().copyWith(
            fontSize: headlineSmall,
            color: glLightHeadingColor,
            fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins().copyWith(
            fontSize: headlineMedium,
            color: glLightHeadingColor,
            fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins().copyWith(
            fontSize: headlineLarge,
            color: glLightHeadingColor,
            fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.poppins().copyWith(
            fontSize: bodyLarge,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.poppins().copyWith(
            fontSize: bodyMedium,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.poppins().copyWith(
            fontSize: bodySmall,
            color: glLightHeadingColor,
            fontWeight: FontWeight.w400),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}
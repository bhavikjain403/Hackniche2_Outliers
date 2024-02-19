import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nomnom/firebase_options.dart';
import 'package:nomnom/screens/auth/onboarding.dart';
import 'package:nomnom/screens/home/home_screen.dart';
import 'package:nomnom/utils/shared_prefs.dart';
import 'utils/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

Future<void> initFCM(FirebaseMessaging messaging) async {
  await messaging.requestPermission();
  final token = await messaging.getToken();
  print('token is ' + token!);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupInteractedMessage();
}

void _handleMessage(RemoteMessage message) {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefs.init();
  // 
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await initFCM(messaging);
//  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: Get.nestedKey(1),
        debugShowCheckedModeBanner: false,
        theme: AppColors.defaultTheme,
        themeMode: ThemeMode.light,
        title: 'NomNom',
        home: !SharedPrefs.getIsFirstInstalled()
            ? HomeScreen()
            : OnBoardingScreen());
    // home:  BookMeeting());
    // home: const HomeScreen());
  }
}

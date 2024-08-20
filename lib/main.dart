import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Screen/Splashscreen.dart';
import 'Utils/AppTheme.dart';
import 'Utils/Themeprovider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkTheme = ref.watch(appThemeProvider);
    final isGoldenTheme = ref.watch(goldenThemeProvider);
    return MaterialApp(
      title: 'ME',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context, isDarkTheme, isGoldenTheme),
      home: SplashScreen(),
    );
  }
}

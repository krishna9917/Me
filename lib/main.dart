import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Resources/Strings.dart';
import 'Screen/Splashscreen.dart';
import 'Utils/AppTheme.dart';
import 'Utils/Themeprovider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in the background message handler (for mobile platforms)
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Web initialization is already done in index.html. No need to do it here.
    // If you must initialize in Dart code, ensure FirebaseOptions are provided.
  } else if (Platform.isIOS || Platform.isAndroid) {
    // Initialize Firebase for mobile platforms
    await Firebase.initializeApp(
      name: 'MeOnlineTrade',
      options: const FirebaseOptions(
        apiKey: "AIzaSyAOCV4nwzCNwSZyUBLHkDV8RsNG6bZ2xG0",
        projectId: "meonlinetrade-38bce",
        messagingSenderId: "805539879858",
        appId: "1:805539879858:web:d97a6fd6b4daf8d7f862ab",
      ),
    );
  }

  // Set up background message handler only for mobile platforms
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkTheme = ref.watch(appThemeProvider);
    var isGoldenTheme = ref.watch(goldenThemeProvider);

    if (!isGoldenTheme && !isDarkTheme) {
      Future<String> selectedTheme = getSelectedTheme();
      isGoldenTheme = selectedTheme.toString().contains(Strings.goldenTheme);
      isDarkTheme = selectedTheme.toString().contains(Strings.darkTheme);
    }

    return MaterialApp(
      title: 'ME',
      debugShowCheckedModeBanner: false,
      theme: getAppTheme(context, isDarkTheme, isGoldenTheme),
      home: const SplashScreen(),
    );
  }
}

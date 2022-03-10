import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/notifiers/news_notifier.dart';
import 'package:newsapp/pages/home/app-layout.dart';
import 'package:newsapp/pages/onboarding.dart';
import 'package:newsapp/pages/sign_in.dart';
import 'package:newsapp/pages/sign_up.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:hive_flutter/hive_flutter.dart';

bool isLoggedIn = false;
User? currentUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    statusBarBrightness: Brightness.light, //status bar brigtness
    statusBarIconBrightness: Brightness.dark, //status barIcon Brightness
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
  ));

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your applicatio

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsAppNow',
      theme: light,
      home: AuthenticationWrapper(),
      routes: {
        '/applayout': (context) => TabLayout(),
        '/onboarding': (context) => const Onboarding(),
        '/sign_in': (context) => SignIn(),
        '/sign_up': (context) => SignUp(),
      },
    );
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          return TabLayout();
        }
        return const Onboarding();
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return Scaffold(
          body: Center(
            child: Text("OOPS"),
          ),
        );
      },
    );
  }
}

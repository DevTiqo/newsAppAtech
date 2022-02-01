import 'package:newsapp/models/news.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/notifiers/news_notifier.dart';
import 'package:newsapp/pages/Onboarding.dart';
import 'package:newsapp/pages/home/app-layout.dart';
import 'package:newsapp/pages/home/notification.dart';
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
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
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

  // print(currentUser.token);
  // isLoggedIn = box.get('isLoggedIn') ?? false;
  // currentUser = await UserPreferences().getUser();

  runApp(
    MyApp(),
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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (currentUser == null || currentUser!.token!.length > 10) {
    //   Provider.of<AuthNotifier>(context, listen: false).setUser(currentUser!);
    // } else {}
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'newsapp',
      theme: light,
      home: Onboarding(),
      // home: FutureBuilder<bool>(
      //     future: hasUserLogged(),
      //     builder: (context, snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //         case ConnectionState.waiting:
      //           return Scaffold(
      //             body: Center(
      //               child: Container(
      //                   width: 100,
      //                   height: 100,
      //                   child: CircularProgressIndicator()),
      //             ),
      //           );
      //         default:
      //           if (snapshot.hasData && snapshot.data!) {
      //             return isLoggedIn
      //                 ? currentUser == null ||
      //                         currentUser!.prefferedLocation == null
      //                     ? const LocationPage()
      //                     : TabLayout()
      //                 : const Onboarding();
      //           } else {
      //             return Onboarding();
      //           }
      //       }
      //     },),
      routes: {
        '/applayout': (context) => TabLayout(),
        '/onboarding': (context) => const Onboarding(),
        '/sign_in': (context) => SignIn(),
        '/sign_up': (context) => SignUp(),
      },
    );
  }
}

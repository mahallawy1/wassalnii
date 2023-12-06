import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'intro.dart';
import 'signUp.dart';
import 'cart.dart';
import 'auth.dart';
import 'RoutesPage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  /*sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;*/
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCIRyi5jXInZ-8TjdWkTIsXmFUta9UAoTI",
        appId: "1:88804464736:android:59511b84332c4895d20b05",
        messagingSenderId: "88804464736",
        projectId: "wassalnii-af003",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => WelcomeScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/routesOptions': (context) => RoutesPage(),
      },
    );
  }

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome Screen',
      home: WelcomeScreen(),
    );
  }
}
*/

}
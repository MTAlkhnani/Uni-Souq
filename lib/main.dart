choco upgrade dart-sdkimport 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:flutter/services.dart';

// Screens
import 'screens/customer_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registeration_screen.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UniSouq());
}

class UniSouq extends StatelessWidget {
  const UniSouq({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation
          .portraitDown, // this has to do with device being tilted i think
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        CustomerScreen.id: (context) => const CustomerScreen(),
        // ProfileScreen.id: (context) => const ProfileScreen(),
      },
    );
  }
}

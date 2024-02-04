import 'package:flutter/material.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import 'login_screen.dart';
import 'registeration_screen.dart';
import '../components/background.dart';
import '../components/Rounded_Button.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: FadeInAnimation(
            delay: 2.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('assets/images/img_uni_souq_1.png'),
                  ),
                ),
                const SizedBox(height: 80),
                const Text(
                  'Welcome to UNI_SOUQ📦',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 139, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 50),
                RoundedButton(
                  text: 'LOGIN',
                  color: const Color.fromRGBO(0, 0, 139, 1),
                  press: () {
                    Navigator.of(context).pushNamed(LoginScreen.id);
                  },
                ),
                const SizedBox(height: 15),
                RoundedButton(
                  text: 'SIGNUP',
                  color: const Color.fromRGBO(0, 0, 139, 1),
                  press: () =>
                      Navigator.of(context).pushNamed(RegistrationScreen.id),
                ),
                const SizedBox(height: 20), // Add additional space if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import '../components/background.dart';
import 'login_screen.dart';
import 'registeration_screen.dart';
import 'package:flutter/material.dart';

import '../components/Rounded_Button.dart';

/*class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child:  Container(
                child: const Text(
                  'WPMS 📦',
                  style: TextStyle(
                      fontSize: 42.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              btnName: 'Log in',
              color: Colors.lightBlueAccent,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              btnName: 'Register',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}*/

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            //margin: const EdgeInsets.only(top: 80, bottom: 80),
            child: Image.asset('assets/images/wpms.png'),
          ),
          const SizedBox(height: 80),
          const Text(
            'Welcome to WPMS📦',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(0, 0, 139, 1),
                fontWeight: FontWeight.bold,
                fontSize: 25),
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
            press: () => Navigator.of(context).pushNamed(RegistrationScreen.id),
          ),
        ],
      )),
    );
  }
}

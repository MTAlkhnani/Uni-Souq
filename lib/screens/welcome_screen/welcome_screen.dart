import 'package:flutter/material.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import 'package:unisouq/screens/intro_boarding/onboarding.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delayed navigation after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, OnboardingScreen.id);
    });

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundImage(),
          Center(
            child: FadeInAnimation(
              delay: 2.2,
              child: Image.asset(
                'assets/images/uni_souq.png', // Your logo image
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, OnboardingScreen.id);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        20), // Customize border radius here
                  ),
                  child: Text(
                    'Uni_Souq',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .primaryColor, // Customize text color here
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

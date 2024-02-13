import 'package:flutter/material.dart';
import 'package:unisouq/screens/customer_screen.dart';
import 'package:unisouq/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:unisouq/screens/information_screen/information_screen.dart';
import 'package:unisouq/screens/intro_boarding/onboarding.dart';
import 'package:unisouq/screens/reset_password_screen/reset_password_screen.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';
import 'package:unisouq/screens/verification_code_screen/verification_code_screen.dart';
import 'package:unisouq/screens/welcome_screen/welcome_screen.dart';
import 'package:unisouq/screens/home_screen/home_screen.dart';

class AppRoutes {
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String verificationCodeScreen = '/verification_code_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String initialRoute = '/welcome_screen';
  static const String customerScreen = '/customer_screen';
  static const String onboardingScreen = '/onboarding_screen';
  static const String informationScreen = '/information_screen';
  static const String homeScreen = '/home_screen';

  static Map<String, WidgetBuilder> routes = {
    WelcomeScreen.id: (context) => WelcomeScreen(),
    LoginScreen.id: (context) => LoginScreen(),
    RegistrationScreen.id: (context) => RegistrationScreen(),
    CustomerScreen.id: (context) => CustomerScreen(),
    ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
    VerificationCodeScreen.id: (context) => VerificationCodeScreen(),
    ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
    OnboardingScreen.id: (context) => OnboardingScreen(),
    InformationScreen.id: (context) => InformationScreen(),
    HomeScreen.id: (context) => HomeScreen(),

    //.................
    informationScreen: (context) => InformationScreen(),
    // ignore: equal_keys_in_map
    onboardingScreen: (context) => const OnboardingScreen(),
    resetPasswordScreen: (context) => ResetPasswordScreen(),
    verificationCodeScreen: (context) => VerificationCodeScreen(),
    customerScreen: (context) => WelcomeScreen(),
    signInScreen: (context) => LoginScreen(),
    signUpScreen: (context) => RegistrationScreen(),
    forgotPasswordScreen: (context) => ForgotPasswordScreen(),
    initialRoute: (context) => WelcomeScreen(),
    homeScreen: (context) => HomeScreen(),
  };
}

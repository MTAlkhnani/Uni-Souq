import 'package:flutter/material.dart';
import 'package:unisouq/screens/customer_screen.dart';
import 'package:unisouq/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:unisouq/screens/intro_boarding/onboarding.dart';
import 'package:unisouq/screens/reset_password_screen/reset_password_screen.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';
import 'package:unisouq/screens/verification_code_screen/verification_code_screen.dart';
import 'package:unisouq/screens/welcome_screen/welcome_screen.dart';

class AppRoutes {
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String verificationCodeScreen = '/verification_code_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String initialRoute = '/welcome_screen';
  static const String customerScreen = '/customer_screen';
  static const String onboardingScreen = '/onboarding_screen';

  static Map<String, WidgetBuilder> routes = {
    WelcomeScreen.id: (context) => const WelcomeScreen(),
    LoginScreen.id: (context) => const LoginScreen(),
    RegistrationScreen.id: (context) => const RegistrationScreen(),
    CustomerScreen.id: (context) => const CustomerScreen(),
    ForgotPasswordScreen.id: (context) => const ForgotPasswordScreen(),
    VerificationCodeScreen.id: (context) => const VerificationCodeScreen(),
    ResetPasswordScreen.id: (context) => const ResetPasswordScreen(),
    OnboardingScreen.id: (context) => const OnboardingScreen(),

    //.................
    onboardingScreen: (context) => const OnboardingScreen(),
    resetPasswordScreen: (context) => const ResetPasswordScreen(),
    verificationCodeScreen: (context) => const VerificationCodeScreen(),
    customerScreen: (context) => const WelcomeScreen(),
    signInScreen: (context) => const LoginScreen(),
    signUpScreen: (context) => const RegistrationScreen(),
    forgotPasswordScreen: (context) => const ForgotPasswordScreen(),
    initialRoute: (context) => const WelcomeScreen(),
  };
}

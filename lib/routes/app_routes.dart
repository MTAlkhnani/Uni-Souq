import 'package:flutter/material.dart';

import 'package:unisouq/screens/edit_product_screen/edit_product.dart';
import 'package:unisouq/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:unisouq/screens/information_screen/information_screen.dart';
import 'package:unisouq/screens/intro_boarding/onboarding.dart';
import 'package:unisouq/screens/massaging_screan/contact_ciients_page.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/screens/my_collection_Screen/my_collection_page.dart';
import 'package:unisouq/screens/myorder_page/myorder_page.dart';
import 'package:unisouq/screens/order_information/confirmation_page.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';

import 'package:unisouq/screens/request_page/request_page.dart';
import 'package:unisouq/screens/reset_password_screen/reset_password_screen.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';
import 'package:unisouq/screens/verification_code_screen/verification_code_screen.dart';
import 'package:unisouq/screens/welcome_screen/welcome_screen.dart';
import 'package:unisouq/screens/home_screen/home_screen.dart';
import 'package:unisouq/screens/add_product/add_product.dart';
import 'package:unisouq/screens/Search_Screen/searchScreen.dart';

class AppRoutes {
  static const String signInScreen = '/sign_in_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String verificationCodeScreen = '/verification_code_screen';
  static const String resetPasswordScreen = '/reset_password_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String initialRoute = 'welcome_screen';

  static const String onboardingScreen = '/onboarding_screen';
  static const String informationScreen = '/information_screen';
  static const String homeScreen = '/home_screen';
  static const String addProduct = '/add_product';
  static const String productDetail = '/product_Detail';
  static const String massagingPage = '/massaging_page';
  static const String editProduct = '/edit_product';
  static const String contactclientspage = '/contact_clients_page';
  static const String myorderpage = '/myorder_page';

  static const String searchScreen = '/search_screen';
  static const String requestpage = '/request_page';
  static const String confirmationpage = '/confirmation_page';
  static const String mycollrctionpage = '/mycollection_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signInScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUpScreen:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case verificationCodeScreen:
        return MaterialPageRoute(
            builder: (_) => const VerificationCodeScreen());

      case resetPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case confirmationpage:
        return MaterialPageRoute(builder: (_) => ConfirmationPage());
      case searchScreen:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case onboardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case informationScreen:
        return MaterialPageRoute(
            builder: (_) => InformationScreen(
                  userId: '',
                ));
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case addProduct:
        return MaterialPageRoute(builder: (_) => AddProductScreen());
      case productDetail:
        return MaterialPageRoute(
            builder: (_) => ProductDetailPage(
                  productId: '',
                ));
      case massagingPage:
        return MaterialPageRoute(
            builder: (_) => MessagingPage(
                  receiverUserID: '',
                ));

      case editProduct:
        return MaterialPageRoute(
            builder: (_) => EditProductScreen(
                  productData: {},
                ));
      case contactclientspage:
        return MaterialPageRoute(builder: (_) => ContactClientsPage());
      case myorderpage:
        return MaterialPageRoute(builder: (_) => MyOrderpage());
      case requestpage:
        return MaterialPageRoute(builder: (_) => RequestPage());
      case mycollrctionpage:
        return MaterialPageRoute(builder: (_) => MyCollectionPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

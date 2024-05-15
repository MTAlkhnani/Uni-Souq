import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unisouq/components/My_text_field.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import 'package:unisouq/constants/constants.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/global.dart';
import 'package:unisouq/routes/app_routes.dart';

import 'package:unisouq/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:unisouq/service/notification_service.dart';
import 'package:unisouq/utils/size_utils.dart';

import '../../components/background.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _loadRememberMe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      final String savedEmail = prefs.getString('savedEmail') ?? '';
      final String savedPassword = prefs.getString('savedPassword') ?? '';
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late final passwordController = TextEditingController();
  late final emailController = TextEditingController();
  BuildContext? lastContext;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool _rememberMe = false;

  void _onRememberMeChanged(bool? newValue) async {
    setState(() {
      _rememberMe = newValue!;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('savedEmail', emailController.text);
      await prefs.setString('savedPassword', passwordController.text);
    } else {
      await prefs.remove('savedEmail');
      await prefs.remove('savedPassword');
    }
  }

  bool _isLogingIn = false;
  void _submitForm(String email, String password) async {
    setState(() {
      _isLogingIn = true;
    });

    try {
      // Attempt to sign in the user with the provided credentials.
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      String userId = userCredential.user!.uid;

      // Check if the user is in the banned_users collection.
      DocumentSnapshot bannedUserSnapshot = await FirebaseFirestore.instance
          .collection('banned_users')
          .doc(userId)
          .get();

      if (bannedUserSnapshot.exists) {
        // If the user is banned, show a message and do not proceed further.
        showErrorMessage(context, S.of(context).bannedMessage);
      } else {
        // If the user is not banned, proceed with the login process.
        if (_rememberMe) {
          // Save the "Remember me" state and/or user credentials as needed.
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('savedEmail', emailController.text);
          await prefs.setString('savedPassword', passwordController.text);
        }
        // Use Navigator to pushReplacementNamed.
        showSuccessMessage(context, S.of(context).loginsucc);
        Future.delayed(const Duration(seconds: 2), () {
          Global.storageService
              .setBool(AppConstrants.STORAGE_DEVICE_SING_IN_KEY, true);

          Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        });
      }
    } on FirebaseAuthException catch (error) {
      var message = S.of(context).massage;
      if (error.message != null) {
        message = error.message.toString();
      }
      showErrorMessage(context, message);
    } catch (error) {
      print(error); // Consider handling this error in a user-friendly way.
    }

    setState(() {
      _isLogingIn = false;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _submitForm(emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Background(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.v),
                      child: Text(
                        S.of(context).trans,
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      'GreatVibes', // Apply the GreatVibes font family here
                                ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      S.of(context).welcome,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: FadeInAnimation(
                        delay: 2.2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            MyTextField(
                              autovalidate: true,
                              controller: emailController,
                              hintText: S.of(context).email,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: CupertinoIcons.mail_solid,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return S.of(context).if1;
                                } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                    .hasMatch(val)) {
                                  return S.of(context).emailv;
                                }
                                return null;
                              },
                              onSaved: (userEmail) {
                                emailController.text = userEmail;
                              },
                            ),
                            const SizedBox(height: 10),
                            MyTextField(
                              controller: passwordController,
                              hintText: S.of(context).pass,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: CupertinoIcons.lock_fill,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                    if (obscurePassword) {
                                      iconPassword = CupertinoIcons.eye_fill;
                                    } else {
                                      iconPassword =
                                          CupertinoIcons.eye_slash_fill;
                                    }
                                  });
                                },
                                icon: Icon(iconPassword),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return S.of(context).if1;
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                    .hasMatch(val)) {
                                  return S.of(context).passv;
                                }
                                return null;
                              },
                              onSaved: (userPassword) {
                                passwordController.text = userPassword;
                              },
                              obscureText: obscurePassword,
                            ),
                            const SizedBox(height: 25),
                            if (_isLogingIn)
                              CircularProgressIndicator(
                                color: Theme.of(context).hintColor,
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Ensures the checkbox takes up minimal space
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged:
                                            _onRememberMeChanged, // Use your method here
                                      ),
                                      Text(S.of(context).REMMBER),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      onTapTxtForgotPassword(context);
                                    },
                                    child: Text(
                                      S.of(context).passforget,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            if (!_isLogingIn)
                              RoundedButton(
                                text: S.of(context).login,
                                color: Theme.of(context).primaryColor,
                                press: _trySubmit,
                              ),
                            if (!_isLogingIn)
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(S.of(context).notmember),
                                          TextButton(
                                            child: Text(
                                              S.of(context).regsternow,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        AppRoutes.signUpScreen),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(S.of(context).Justbrowsing),
                                          TextButton(
                                            child: Text(
                                              S.of(context).Guest,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    AppRoutes.homeScreen),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the forgotPasswordScreen when the action is triggered.
  onTapTxtForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

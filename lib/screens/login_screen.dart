import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unisouq/components/My_text_field.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/common.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import '../components/background.dart';
import 'customer_screen.dart';
import 'registeration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  BuildContext? lastContext;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;

  bool _isLogingIn = false;

  void _submiteForm(String email, String password) async {
    setState(() {
      _isLogingIn = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(lastContext!).pop();
      Navigator.of(lastContext!).pushReplacementNamed(CustomerScreen.id);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurd, please check your credentials!';
      if (error.message != null) {
        message = error.message.toString();
        ScaffoldMessenger.of(lastContext!)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      // ignore: avoid_print
      print(error);
    }
    setState(() {
      _isLogingIn = false;
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      _submiteForm(emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        body: Background(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    Text(
                      'Transforming Campus Life \nwith Every Login.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              fontSize: 20,
                              color: const Color.fromRGBO(0, 0, 139, 1),
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome back, you\'ve been missed!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
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
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: CupertinoIcons.mail_solid,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                    .hasMatch(val)) {
                                  return 'Please enter a valid email';
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
                              hintText: 'Password',
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
                                  return 'Please fill in this field';
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                    .hasMatch(val)) {
                                  return 'Please enter a valid password';
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
                              const CircularProgressIndicator(
                                color: Color.fromRGBO(0, 0, 139, 1),
                              ),
                            if (!_isLogingIn)
                              RoundedButton(
                                text: 'Login',
                                color: const Color.fromRGBO(0, 0, 139, 1),
                                press: _trySubmit,
                              ),
                            if (!_isLogingIn)
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        FadeInAnimation(
                                          delay: 2.2,
                                          child: Text(
                                            "Or Log with",
                                            style: Common().semiboldblack,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        FadeInAnimation(
                                          delay: 2.4,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                right: 30,
                                                left: 30),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/images/google_ic-1.svg"),
                                                Image.asset(
                                                    "assets/images/Vector.png")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (!_isLogingIn)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Not a member?'),
                                  TextButton(
                                    child: const Text(
                                      'Register now',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 139, 1),
                                      ),
                                    ),
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacementNamed(
                                            RegistrationScreen.id),
                                  )
                                ],
                              ),
                            const SizedBox(height: 100)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 30,
                  left: 5,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: const Color.fromRGBO(0, 0, 139, 1),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

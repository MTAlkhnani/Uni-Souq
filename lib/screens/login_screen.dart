import 'package:flutter/cupertino.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import '../components/background.dart';
import 'customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _errorMsg;

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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 100),
                  Text(
                    'Track Your Shipment Now!',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 23,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: emailController,
                              key: const ValueKey('email'),
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorText: _errorMsg,
                                prefixIcon:
                                    const Icon(CupertinoIcons.mail_solid),
                                hintText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 0, 139, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
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
                                emailController.text = userEmail!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              key: const ValueKey('password'),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: obscurePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(CupertinoIcons.lock_fill),
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                errorText: _errorMsg,
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 0, 139, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                                passwordController.text = userPassword!;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        if (_isLogingIn)
                          const CircularProgressIndicator(
                            color: Color.fromRGBO(0, 0, 139, 1),
                          ),
                        if (!_isLogingIn)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: RoundedButton(
                              text: 'Login',
                              color: const Color.fromRGBO(0, 0, 139, 1),
                              press: _trySubmit,
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

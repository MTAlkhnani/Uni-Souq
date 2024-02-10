import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/components/My_text_field.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import '../../components/background.dart';
import '../customer_screen.dart';
import '../sign_in_screen/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/sign-up';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  BuildContext? lastContext;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phoneController = TextEditingController();
  bool twoFactorEnabled = false;

  final _formKey = GlobalKey<FormState>();

  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;

  bool isSigningUp = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  void _submiteForm(String email, String password, String username,
      String phone, String address) async {
    setState(() {
      isSigningUp = true;
    });
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseFirestore.instance
          .collection('Customer')
          .doc(userCredential.user!.uid)
          .set({
        'CustomerId': userCredential.user!.uid,
        'CustomerName': username,
        'Email': userCredential.user!.email,
        'Address': address,
        'Phone': phone,
      });

      Navigator.of(lastContext!).pop();
      Navigator.of(lastContext!).pushReplacementNamed(CustomerScreen.id);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials!';
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
      isSigningUp = false;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      _submiteForm(
          emailController.text.trim(),
          passwordController.text.trim(),
          firstnameController.text.trim(),
          lastnameController.text.trim(),
          phoneController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return Scaffold(
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
                    Text(
                      'Hello There!',
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontSize: 40,

                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    'GreatVibes', // Apply the GreatVibes font family here
                              ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Register below with your detail',
                      style: TextStyle(
                        fontSize: 20,
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
                              controller: firstnameController,
                              hintText: 'First Name',
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (val.length > 30) {
                                  return 'Name too long';
                                } else if (val.length < 2) {
                                  return 'Name too short';
                                }
                                return null;
                              },
                              onSaved: (firstname) {
                                firstnameController.text = firstname;
                              },
                            ),
                            const SizedBox(
                                height: 10), // Added consistent spacing
                            MyTextField(
                              controller: lastnameController,
                              hintText: 'Last Name',
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (val.length > 30) {
                                  return 'Name too long';
                                } else if (val.length < 2) {
                                  return 'Name too short';
                                }
                                return null;
                              },
                              onSaved: (lasttname) {
                                lastnameController.text = lasttname;
                              },
                            ),
                            const SizedBox(
                                height: 10), // Added consistent spacing
                            MyTextField(
                              autovalidate: true,
                              controller: phoneController,
                              hintText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone,
                              validator: (value) {
                                if (value!.isEmpty || value.length != 10) {
                                  return 'Please enter a valid phone number.';
                                }
                                return null;
                              },
                              onSaved: (phone) {
                                phoneController.text = phone;
                              },
                            ),
                            const SizedBox(
                                height: 10), // Added consistent spacing
                            MyTextField(
                              autovalidate: true,
                              controller: emailController,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
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
                            const SizedBox(
                                height: 10), // Added consistent spacing
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
                              onChanged: (val) {
                                if (val.contains(RegExp(r'[A-Z]'))) {
                                  setState(() {
                                    containsUpperCase = true;
                                  });
                                } else {
                                  setState(() {
                                    containsUpperCase = false;
                                  });
                                }
                                if (val.contains(RegExp(r'[a-z]'))) {
                                  setState(() {
                                    containsLowerCase = true;
                                  });
                                } else {
                                  setState(() {
                                    containsLowerCase = false;
                                  });
                                }
                                if (val.contains(RegExp(r'[0-9]'))) {
                                  setState(() {
                                    containsNumber = true;
                                  });
                                } else {
                                  setState(() {
                                    containsNumber = false;
                                  });
                                }
                                if (val.contains(RegExp(
                                    r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                  setState(() {
                                    containsSpecialChar = true;
                                  });
                                } else {
                                  setState(() {
                                    containsSpecialChar = false;
                                  });
                                }
                                if (val.length >= 8) {
                                  setState(() {
                                    contains8Length = true;
                                  });
                                } else {
                                  setState(() {
                                    contains8Length = false;
                                  });
                                }
                                return;
                              },
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
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  1 uppercase",
                                      style: TextStyle(
                                          color: containsUpperCase
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                    Text(
                                      "⚈  1 lowercase",
                                      style: TextStyle(
                                          color: containsLowerCase
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                    Text(
                                      "⚈  1 number",
                                      style: TextStyle(
                                          color: containsNumber
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  1 special character",
                                      style: TextStyle(
                                          color: containsSpecialChar
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                    Text(
                                      "⚈  8 minimum character",
                                      style: TextStyle(
                                          color: contains8Length
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    10), // Added consistent spacing for the password rules
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      25), // Match the padding of other fields
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.security),
                                        SizedBox(
                                            width:
                                                16), // Adjust space between the icon and text
                                        Text(
                                            'Enable Two-Factor Authentication'),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: twoFactorEnabled,
                                    onChanged: (bool value) {
                                      setState(() {
                                        twoFactorEnabled = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height:
                                    10), // Added consistent spacing before signup button
                            if (isSigningUp)
                              const CircularProgressIndicator(
                                  color: Color.fromRGBO(0, 0, 139, 1)),
                            if (!isSigningUp)
                              RoundedButton(
                                text: 'Signup',
                                color: Theme.of(context).primaryColor,
                                press: _submit,
                              ),
                            const SizedBox(
                                height:
                                    10), // Added before "I am a member" row for consistency
                            if (!isSigningUp)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('I am a member!'),
                                  TextButton(
                                    child: Text(
                                      'Login now',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () => Navigator.of(context)
                                        .pushReplacementNamed(LoginScreen.id),
                                  ),
                                ],
                              ),
                            const SizedBox(
                                height: 80), // Consistent bottom spacing
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
                  color: Theme.of(context).hintColor,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

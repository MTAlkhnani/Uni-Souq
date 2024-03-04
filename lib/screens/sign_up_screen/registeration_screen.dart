import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/My_text_field.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:unisouq/components/fade_animationtest.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/information_Screen/information_screen.dart';

import '../../components/background.dart';
// import '../customer_screen.dart';
import '../sign_in_screen/login_screen.dart';
import '../verification_code_screen/notifier/verification_code_notifier.dart';
import '../verification_code_screen/verification_code_screen.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  static String id = '/sign-up';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
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

  void _submiteForm(String email, String password, String firstName,
      String lastName, String phone) async {
    setState(() {
      isSigningUp = true;
    });
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userCredential.user!.uid)
          .set({
        'UserId': userCredential.user!.uid,
        'FirstName': firstName,
        'LastName': lastName,
        'Email': userCredential.user!.email,
        'Phone': phone,
        'TwoFactorAuth': twoFactorEnabled,
      });
      await FirebaseFirestore.instance
          .collection('Profile')
          .doc(userCredential.user!.uid)
          .set({
        'userId': userCredential.user!.uid,
        'fName': firstName,
        'lName': lastName,
        'phone': phone,
        'university': '',
        'userImage': null,
        'address': '',
      });
      // Dismiss any open dialogs or loading indicators
      Navigator.of(context).pop();

      // Check if two-factor authentication is enabled
      if (twoFactorEnabled) {
        ref
            .read(verificationCodeNotifier.notifier)
            .setPhoneNumber(phone); // Update the notifier with the phone number

        Navigator.pushReplacementNamed(
            context, AppRoutes.verificationCodeScreen);
      } else {
        // If two-factor authentication is not enabled, proceed to the CustomerScreen
        showSuccessMessage(context, S.of(context).succmassage);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InformationScreen(
              userId: userCredential.user!.uid,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      var message = S.of(context).massage;
      if (error.message != null) {
        message = error.message.toString();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(message)));
        showErrorMessage(context, message);
      }
      // Dismiss any open dialogs or loading indicators
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      print(error);
    }
    setState(() {
      isSigningUp = false;
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();

      // Check if the email is already in use
      final existingUser = await FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: emailController.text.trim())
          .get();

      if (existingUser.docs.isNotEmpty) {
        // Email is already in use
        showErrorMessage(context, 'Email is already in use!');
      } else {
        // Email is not in use, proceed with registration
        _submiteForm(
            emailController.text.trim(),
            passwordController.text.trim(),
            firstnameController.text.trim(),
            lastnameController.text.trim(),
            phoneController.text.trim());
      }
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
                      S.of(context).HelleThere,
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                                fontSize: 40,

                                fontWeight: FontWeight.bold,
                                fontFamily:
                                    'GreatVibes', // Apply the GreatVibes font familyF here
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).reg,
                      style: const TextStyle(
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
                              hintText: S.of(context).hint,
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return S.of(context).if1;
                                } else if (val.length > 30) {
                                  return S.of(context).if_else1;
                                } else if (val.length < 2) {
                                  return S.of(context).if_else2;
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
                              hintText: S.of(context).hintL,
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return S.of(context).if1;
                                } else if (val.length > 30) {
                                  return S.of(context).if_else1;
                                } else if (val.length < 2) {
                                  return S.of(context).if_else2;
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
                              hintText: S.of(context).hintn,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length != 10 ||
                                    !value.startsWith('05')) {
                                  return S.of(context).numv;
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
                              hintText: S.of(context).email,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
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
                            const SizedBox(
                                height: 10), // Added consistent spacing
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
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal:
                            //           35), // Match the padding of other fields
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Flexible(
                            //         child: Row(
                            //           children: [
                            //             Icon(Icons.security),
                            //             SizedBox(
                            //                 width:
                            //                     2), // Adjust space between the icon and text
                            //             Text(
                            //                 'Enable Two-Factor Authentication'),
                            //           ],
                            //         ),
                            //       ),
                            //       Switch(
                            //         value: twoFactorEnabled,
                            //         activeColor: Theme.of(context).primaryColor,
                            //         onChanged: (bool value) {
                            //           setState(() {
                            //             twoFactorEnabled = value;
                            //           });
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            const SizedBox(
                                height:
                                    10), // Added consistent spacing before signup button
                            if (isSigningUp)
                              const CircularProgressIndicator(
                                  color: Color.fromRGBO(142, 108, 239, 1)),
                            if (!isSigningUp)
                              RoundedButton(
                                text: S.of(context).sginup,
                                color: Theme.of(context).primaryColor,
                                press: _submit,
                              ),
                            const SizedBox(
                                height:
                                    10), // Added before "I am a member" row for consistency
                            if (!isSigningUp)
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
                                           Text(S.of(context).member),
                                          TextButton(
                                            child: Text(
                                              S.of(context).login,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pushReplacementNamed(
                                                        AppRoutes.signInScreen),
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

                            const SizedBox(
                                height: 80), // Consistent bottom spacing
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

  @override
  void dispose() {
    // Dispose controllers to free up resources
    passwordController.dispose();
    emailController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

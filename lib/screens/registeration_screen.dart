import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import '../components/background.dart';
import 'customer_screen.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = '/sign-up';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  BuildContext? lastContext;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

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
          usernameController.text.trim(),
          phoneController.text.trim(),
          addressController.text.trim());
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
                      'HELLO THERE!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              fontSize: 30,
                              color: const Color.fromRGBO(0, 0, 139, 1),
                              fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Register below with your detail',
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
                          // UserImage(profileImage: _pickedImage),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                key: const ValueKey('Username'),
                                controller: usernameController,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: 'Username',
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
                                        color: Color.fromRGBO(0, 0, 139, 1)),
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
                                  } else if (val.length > 30) {
                                    return 'Name too long';
                                  }
                                  return null;
                                },
                                onSaved: (username) {
                                  usernameController.text = username!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                controller: phoneController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                key: const ValueKey('Phone'),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.phone),
                                  hintText: 'Phone Number',
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
                                        color: Color.fromRGBO(0, 0, 139, 1)),
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
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 10) {
                                    return 'Please enter a valid phone number.';
                                  }
                                  return null;
                                },
                                onSaved: (phone) {
                                  phoneController.text = phone!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                controller: emailController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                key: const ValueKey('email'),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email),
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
                                        color: Color.fromRGBO(0, 0, 139, 1)),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                controller: passwordController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                key: const ValueKey('password'),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obscurePassword,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(CupertinoIcons.lock_fill),
                                  hintText: 'Password',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                        if (obscurePassword) {
                                          iconPassword =
                                              CupertinoIcons.eye_fill;
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
                                        color: Color.fromRGBO(0, 0, 139, 1)),
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
                                  passwordController.text = userPassword!;
                                },
                              ),
                            ),
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
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextFormField(
                                controller: addressController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                key: const ValueKey('Address'),
                                keyboardType: TextInputType.streetAddress,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.location_city),
                                  hintText: 'Address',
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
                                        color: Color.fromRGBO(0, 0, 139, 1)),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a valid address.';
                                  }
                                  return null;
                                },
                                onSaved: (address) {
                                  addressController.text = address!;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 25),
                          if (isSigningUp)
                            const CircularProgressIndicator(
                                color: Color.fromRGBO(0, 0, 139, 1)),
                          if (!isSigningUp)
                            RoundedButton(
                              text: 'Signup',
                              color: const Color.fromRGBO(0, 0, 139, 1),
                              press: _submit,
                            ),
                          if (!isSigningUp)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('I am a member!'),
                                TextButton(
                                  child: const Text(
                                    'Login now',
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 139, 1)),
                                  ),
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed(LoginScreen.id),
                                )
                              ],
                            ),
                          const SizedBox(height: 80)
                        ],
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

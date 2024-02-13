import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/background.dart';
import 'package:unisouq/components/custom_pin_code_text_field.dart';
import 'package:unisouq/screens/information_screen/information_screen.dart';

// import 'package:unisouq/screens/reset_password_screen/reset_password_screen.dart';
import 'package:unisouq/screens/verification_code_screen/notifier/verification_code_notifier.dart';

import 'package:unisouq/utils/size_utils.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  static const String id = 'verification_code_screen';

  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  VerificationCodeScreenState createState() => VerificationCodeScreenState();
}

class VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
  bool _isVerifyPhoneInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final Size size = MediaQuery.of(context).size;
      SizeUtils.setScreenSize(
          size.width, size.height, MediaQuery.of(context).orientation);
      setState(() {}); // Trigger a rebuild after setting screen size
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the verification phone process has already been initialized to avoid reinitializing
    if (!_isVerifyPhoneInitialized) {
      _verifyPhone();
      _isVerifyPhoneInitialized = true;
    }
  }

  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  String? _verificationCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          final phoneNumber = ref
              .watch(verificationCodeNotifier)
              .verificationCodeModelObj
              ?.phoneNumber;

          return SizedBox(
            width:
                SizeUtils.width, // Access SizeUtils.width after initialization
            child: Background(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        SizedBox(
                          height: 200.v,
                          width: 300.v,
                          child: Image.asset(
                            "assets/images/pin_code.gif",
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'Enter your passcode',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'please enter your passcode that sent to $phoneNumber',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.h),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final otpController = ref
                                  .watch(verificationCodeNotifier)
                                  .otpController;
                              return TextField(
                                controller:
                                    otpController, // Use the same TextEditingController
                                keyboardType: TextInputType
                                    .number, // Ensure number input// Only allow digits
                                decoration: const InputDecoration(
                                  border:
                                      OutlineInputBorder(), // Add a border to each TextField
                                  counterText:
                                      "", // Hide the counter text underneath the TextField
                                ),
                                maxLength: 6, // Set the max length for the OTP
                                onChanged: (value) {
                                  ref
                                      .read(verificationCodeNotifier)
                                      .updateOTP(value); // Update the OTP value
                                },
                                // Style the text field to look like a PIN input if desired
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  letterSpacing:
                                      2.0, // Space out the characters for better readability
                                  fontSize:
                                      22.0, // Increase the font size for better visibility
                                ),
                              );

                              // return CustomPinCodeTextField(
                              //   context: context,
                              //   controller: otpController,
                              //   onChanged: (value) {
                              // ref
                              //     .read(verificationCodeNotifier)
                              //     .updateOTP(value);
                              //   },
                              // );
                            },
                          ),
                        ),
                        SizedBox(height: 15.v),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Didn’t receive a code?",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 20),
                              ),
                              TextSpan(
                                text: "Resend Code",
                                // use here onEnter method to make it clickable
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(flex: 50),
                        Center(
                          child: RoundedButton(
                            text: 'Confirm',
                            color: Theme.of(context).primaryColor,
                            press: () async {
                              final pin =
                                  otpController.text; // Access the OTP value

                              if (_verificationCode != null) {
                                _submit(_verificationCode!,
                                    pin); // Call _submit with the verification code and pin
                              } else {
                                // Handle case where verification code is not available
                                print('Verification code not available.');
                              }
                            },
                          ),
                        ),
                        const Spacer(flex: 74),
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
                        onTapArrowDown(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Navigates back to the previous screen.
  onTapArrowDown(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  /// Navigates to the resetPasswordScreen when the action is triggered.
  onTapConfirm(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(InformationScreen.id);
  }

  Future<dynamic> _verifyPhone() async {
    var phoneNumber = ref
        .watch(verificationCodeNotifier)
        .verificationCodeModelObj
        ?.phoneNumber;
    phoneNumber = phoneNumber?.substring(1, phoneNumber.length);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+966$phoneNumber",
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.message);
      },
      codeSent: (verificationId, forceResendingToken) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  void _submit(String verificationId, String pin) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: pin))
          .then((value) {
        if (value.user != null) {
          onTapConfirm(context);
        }
      });
    } catch (e) {
      print(
          e); // here we should put a snackbar saying that the otp code is wrong
    }
    // Potentially navigate to another screen or show a success message after sign-in
  }
}

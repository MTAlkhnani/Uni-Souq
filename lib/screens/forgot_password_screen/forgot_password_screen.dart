import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/background.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';

import 'package:unisouq/screens/forgot_password_screen/notifier/forgot_password_notifier.dart';
import 'package:unisouq/screens/verification_code_screen/verification_code_screen.dart';

import 'package:unisouq/utils/size_utils.dart';
import 'package:unisouq/utils/validation_functions.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String id = 'forgot_password_screen';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController emailController; // Not nullable
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = ref.read(forgotPasswordNotifier).emailController!;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final Size size = MediaQuery.of(context).size;
      SizeUtils.setScreenSize(
          size.width, size.height, MediaQuery.of(context).orientation);
      setState(() {}); // Trigger a rebuild after setting screen size
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      body: Builder(
        builder: (BuildContext context) {
          if (SizeUtils.width == null) {
            return const SizedBox
                .shrink(); // Return an empty widget if width is not initialized
          }
          return SizedBox(
            width:
                SizeUtils.width, // Access SizeUtils.width after initialization
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Background(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 25.v,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50.h),
                                Center(
                                  child: SizedBox(
                                    width: 279.h,
                                    child: Text(
                                      S
                                          .of(context)
                                          .weneed, // this text is too long
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 60.v),
                                Consumer(builder: (context, ref, _) {
                                  return MyTextField(
                                    controller: emailController,
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: CupertinoIcons.mail_solid,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    validator: (value) {
                                      if (value == null ||
                                          (!isValidEmail(value,
                                              isRequired: true))) {
                                        return "Please enter valid email";
                                      }
                                      return null;
                                    },
                                  );
                                }),
                                SizedBox(height: 20.v),
                                Center(
                                  child: RoundedButton(
                                    text: S.of(context).sendCode,
                                    color: Theme.of(context).primaryColor,
                                    press: () => onTapSendCode(context),
                                  ),
                                ),
                                SizedBox(height: 5.v),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 5,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: const Color.fromRGBO(0, 0, 139, 1),
                        onPressed: () {
                          onTapArrowDown(context);
                        },
                      ),
                    ),
                  ],
                ),
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
    emailController.clear();
  }

  /// Navigates to the verificationCodeScreen when the action is triggered.
  Future onTapSendCode(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());

        // Dismiss the loading dialog
        Navigator.of(context).pop();

        // Show a SnackBar after successful email sending
        showSuccessMessage(context, S.of(context).restemail);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //       content: Text('Reset code has been sent to your email.')),
        // );
        // await Future.delayed(const Duration(seconds: 6));
        // Navigator.popAndPushNamed(context, AppRoutes.signInScreen);
      } on FirebaseAuthException catch (e) {
        // Dismiss the loading dialog
        Navigator.of(context).pop();

        // Handle error, e.g., show error SnackBar
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('')),

        // );
        showErrorMessage(context, "Failed to send reset code: ${e.message}.");
      }
    }
  }

  @override
  void dispose() {
    // Dispose any controllers or resources here

    super.dispose();
  }
}

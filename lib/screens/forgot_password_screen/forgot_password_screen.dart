import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/background.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/forgot_password_screen/notifier/forgot_password_notifier.dart';
import 'package:unisouq/screens/verification_code_screen/verification_code_screen.dart';
import 'package:unisouq/utils/navigator_service.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'package:unisouq/utils/validation_functions.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String id = 'forgot_password_screen';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                                      "We need your registration email to send you password reset code!",
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
                                    controller: ref
                                        .watch(forgotPasswordNotifier)
                                        .emailController,
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
                                    text: 'send Code',
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
  }

  /// Navigates to the verificationCodeScreen when the action is triggered.
  onTapSendCode(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(VerificationCodeScreen.id);
    }
  }

  @override
  void dispose() {
    // Dispose any controllers or resources here
    ref.read(forgotPasswordNotifier).emailController?.dispose();
    super.dispose();
  }
}

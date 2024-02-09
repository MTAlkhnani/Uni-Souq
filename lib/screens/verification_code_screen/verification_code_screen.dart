import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/background.dart';
import 'package:unisouq/components/custom_pin_code_text_field.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/reset_password_screen/reset_password_screen.dart';
import 'package:unisouq/screens/verification_code_screen/notifier/verification_code_notifier.dart';
import 'package:unisouq/utils/navigator_service.dart';
import 'package:unisouq/utils/size_utils.dart';

class VerificationCodeScreen extends ConsumerStatefulWidget {
  static const String id = 'verification_code_screen';
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  VerificationCodeScreenState createState() => VerificationCodeScreenState();
}

class VerificationCodeScreenState
    extends ConsumerState<VerificationCodeScreen> {
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
      body: Builder(
        builder: (BuildContext context) {
          if (SizeUtils.width == null) {
            return const SizedBox
                .shrink(); // Return an empty widget if width is not initialized
          }
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
                        SizedBox(height: 80.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Enter the code we sent your registered email',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontSize: 20,
                                  color: const Color.fromRGBO(0, 0, 139, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(height: 60.v),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: Consumer(
                            builder: (context, ref, _) {
                              return CustomPinCodeTextField(
                                context: context,
                                controller: ref
                                    .watch(verificationCodeNotifier)
                                    .otpController,
                                onChanged: (value) {
                                  ref
                                      .watch(verificationCodeNotifier)
                                      .otpController
                                      ?.text = value;
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15.v),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Did’t receive a code?",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontSize: 20,
                                      color: const Color.fromARGB(
                                          255, 174, 170, 170),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 20),
                              ),
                              TextSpan(
                                text: "Resent Code",
                                // use here onEnter method to make it clickable
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontSize: 15,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const Spacer(flex: 25),
                        Center(
                          child: RoundedButton(
                            text: 'Confirm',
                            color: const Color.fromRGBO(0, 0, 139, 1),
                            press: () => onTapConfirm(context),
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
                      color: const Color.fromRGBO(0, 0, 139, 1),
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
    Navigator.of(context).pushReplacementNamed(ResetPasswordScreen.id);
  }
}

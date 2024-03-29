import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/My_text_field.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/background.dart';
import 'package:unisouq/routes/app_routes.dart';

import 'package:unisouq/screens/reset_password_screen/notifier/reset_password_notifier.dart';

import 'package:unisouq/utils/size_utils.dart';
import 'package:unisouq/utils/validation_functions.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  static const String id = 'reset_password_screen';
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    newPasswordController =
        ref.read(resetPasswordNotifier).newpasswordController!;
    confirmPasswordController =
        ref.read(resetPasswordNotifier).confirmpasswordController!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      body: Builder(builder: (BuildContext context) {
        return SizedBox(
          width: SizeUtils.width,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Background(
              child: Stack(
                children: [
                  Padding(
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 50.h),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    "Enter a new password ",
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
                              SizedBox(height: 47.v),
                              Consumer(builder: (context, ref, _) {
                                final notifier =
                                    ref.watch(resetPasswordNotifier);
                                return Column(
                                  children: [
                                    MyTextField(
                                      controller:
                                          notifier.newpasswordController,
                                      hintText: 'New Password',
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      prefixIcon: CupertinoIcons.lock_fill,
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            notifier.togglePasswordVisibility();
                                          });
                                        },
                                        child: Icon(notifier.isShowPassword
                                            ? CupertinoIcons.eye_slash_fill
                                            : CupertinoIcons.eye_fill),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            (!isValidPassword(value,
                                                isRequired: true))) {
                                          return "please enter a valid password";
                                        }
                                        return null;
                                      },
                                      obscureText: !notifier.isShowPassword,
                                    ),
                                    SizedBox(height: 20.v),
                                    MyTextField(
                                      controller:
                                          notifier.confirmpasswordController,
                                      hintText: 'Confirm Password',
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      prefixIcon: CupertinoIcons.lock_fill,
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            notifier.togglePasswordVisibility();
                                          });
                                        },
                                        child: Icon(notifier.isShowPassword
                                            ? CupertinoIcons.eye_slash_fill
                                            : CupertinoIcons.eye_fill),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value !=
                                                notifier.newpasswordController
                                                    ?.text) {
                                          return "Passwords do not match";
                                        }
                                        return null;
                                      },
                                      obscureText: !notifier.isShowPassword,
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(height: 40.v),
                              Center(
                                child: RoundedButton(
                                  text: 'Confirm',
                                  color: Theme.of(context).primaryColor,
                                  press: () => onTapConfirm(context),
                                ),
                              ),
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
                      color: Theme.of(context).hintColor,
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
      }),
    );
  }

  /// Navigates back to the previous screen.
  onTapArrowDown(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  /// Navigates to the exploreShopScreen when the action is triggered.
  onTapConfirm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    }
  }

  @override
  void dispose() {
    // Dispose any controllers or resources here
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

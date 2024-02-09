import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/screens/reset_password_screen/models/reset_password_model.dart';
part 'reset_password_state.dart';

final resetPasswordNotifier =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>((ref) =>
        ResetPasswordNotifier(ResetPasswordState(
            newpasswordController: TextEditingController(),
            confirmpasswordController: TextEditingController(),
            isShowPassword: false,
            isShowPassword1: false,
            resetPasswordModelObj: ResetPasswordModel())));

/// A notifier that manages the state of a ResetPassword according to the event that is dispatched to it.
class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordNotifier(super.state);

  void changePasswordVisibility() {
    state = state.copyWith(isShowPassword: !(state.isShowPassword ?? false));
  }

  void changePasswordVisibility1() {
    state = state.copyWith(isShowPassword1: !(state.isShowPassword1 ?? false));
  }

  void togglePasswordVisibility() {
    // Toggle the visibility of the password fields
    state = state.copyWith(
      isShowPassword: !state.isShowPassword!,
      isShowPassword1: !state.isShowPassword1!,
    );
  }
}

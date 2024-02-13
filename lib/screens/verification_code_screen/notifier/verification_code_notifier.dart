import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:unisouq/screens/verification_code_screen/models/verification_code_model.dart';
part 'verification_code_state.dart';

final verificationCodeNotifier =
    StateNotifierProvider<VerificationCodeNotifier, VerificationCodeState>(
        (ref) => VerificationCodeNotifier(VerificationCodeState(
            otpController: TextEditingController(),
            verificationCodeModelObj: VerificationCodeModel())));

/// A notifier that manages the state of a VerificationCode according to the event that is dispatched to it.
class VerificationCodeNotifier extends StateNotifier<VerificationCodeState>
    with CodeAutoFill {
  VerificationCodeNotifier(VerificationCodeState state) : super(state);
  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(
      verificationCodeModelObj:
          state.verificationCodeModelObj?.copyWith(phoneNumber: phoneNumber),
    );
  }

  @override
  void codeUpdated() {
    state.otpController?.text = code ?? '';
  }

  void updateOTP(String value) {
    state = state.copyWith(
      otpController: (state.otpController ?? TextEditingController())
        ..text = value.trim(), // Trim the value before updating the text
    );
  }
}

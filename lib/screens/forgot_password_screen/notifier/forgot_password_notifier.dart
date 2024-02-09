
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forgot_password_model.dart';
part 'forgot_password_state.dart';

final forgotPasswordNotifier =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) =>
        ForgotPasswordNotifier(ForgotPasswordState(
            emailController: TextEditingController(),
            forgotPasswordModelObj: ForgotPasswordModel())));

/// A notifier that manages the state of a ForgotPassword according to the event that is dispatched to it.
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  ForgotPasswordNotifier(ForgotPasswordState state) : super(state);
}

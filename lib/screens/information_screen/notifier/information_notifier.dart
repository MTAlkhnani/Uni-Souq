import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/screens/information_screen/models/information_model.dart';
part 'information_state.dart';

final informationNotifier =
    StateNotifierProvider<InformationNotifier, InformationState>((ref) =>
        InformationNotifier(InformationState(
            nameController: TextEditingController(),
            dateOfBirthController: TextEditingController(),
            addressController: TextEditingController(),
            mobileNumberController: TextEditingController(),
            informationModelObj: InformationModel())));

/// A notifier that manages the state of a Information according to the event that is dispatched to it.
class InformationNotifier extends StateNotifier<InformationState> {
  InformationNotifier(InformationState state) : super(state);
}

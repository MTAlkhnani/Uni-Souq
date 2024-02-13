// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

/// This class defines the variables used in the [verification_code_screen],
/// and is typically used to hold data that is passed between different parts of the application.

class VerificationCodeModel extends Equatable {
  final String? phoneNumber; // Make sure this field is defined in your model

  const VerificationCodeModel(
      {this.phoneNumber}); // Include phoneNumber in the constructor

  VerificationCodeModel copyWith({String? phoneNumber}) {
    return VerificationCodeModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [phoneNumber]; // Include phoneNumber in props
}

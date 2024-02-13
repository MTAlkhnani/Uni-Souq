// ignore_for_file: must_be_immutable

part of 'information_notifier.dart';

/// Represents the state of Information in the application.
class InformationState extends Equatable {
  InformationState({
    this.nameController,
    this.dateOfBirthController,
    this.addressController,
    this.mobileNumberController,
    this.id,
    this.informationModelObj,
  });

  TextEditingController? nameController;

  TextEditingController? dateOfBirthController;

  TextEditingController? addressController;

  TextEditingController? mobileNumberController;

  InformationModel? informationModelObj;

  var id;

  @override
  List<Object?> get props => [
        nameController,
        dateOfBirthController,
        addressController,
        mobileNumberController,
        id,
        informationModelObj,
      ];

  InformationState copyWith({
    TextEditingController? nameController,
    TextEditingController? dateOfBirthController,
    TextEditingController? addressController,
    TextEditingController? mobileNumberController,
    var id,
    InformationModel? informationModelObj,
  }) {
    return InformationState(
      nameController: nameController ?? this.nameController,
      dateOfBirthController:
          dateOfBirthController ?? this.dateOfBirthController,
      addressController: addressController ?? this.addressController,
      mobileNumberController:
          mobileNumberController ?? this.mobileNumberController,
      id: id ?? this.id,
      informationModelObj: informationModelObj ?? this.informationModelObj,
    );
  }
}

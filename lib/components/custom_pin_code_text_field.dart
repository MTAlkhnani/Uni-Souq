import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:unisouq/utils/size_utils.dart';

class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField({
    Key? key,
    required this.context,
    required this.onChanged,
    this.alignment,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.validator,
  }) : super(key: key);

  final Alignment? alignment;
  final BuildContext context;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  Function(String) onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget(context),
          )
        : pinCodeTextFieldWidget(context);
  }

  Widget pinCodeTextFieldWidget(BuildContext context) {
    // Calculate the width of the screen minus padding
    final screenWidth =
        MediaQuery.of(context).size.width - (SizeUtils.width * 0.1);
    final fieldWidth = screenWidth / 6; // Divide by the number of fields

    // Calculate the height of the screen minus various elements
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final fieldHeight = (screenHeight - appBarHeight - statusBarHeight) *
        0.1; // Allocate 10% of the remaining height for each field

    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: 5,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      enableActiveFill: true,
      pinTheme: PinTheme(
        fieldHeight: fieldHeight,
        fieldWidth: fieldWidth,
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5.0), // Adjust as needed
        inactiveFillColor: Theme.of(context).highlightColor.withOpacity(0.3),
        activeFillColor: Theme.of(context).hoverColor,
        inactiveColor: Colors.transparent,
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
      ),
      onChanged: (value) => onChanged(value),
      validator: validator,
    );
  }
}

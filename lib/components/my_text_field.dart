import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorMsg;
  final bool autovalidate;
  final void Function(String)? onChanged;
  final void Function(String)? onSaved;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.errorMsg,
    this.autovalidate = false,
    this.onChanged,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextFormField(
          autofocus: true,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          obscureText: obscureText,
          autovalidateMode:
              autovalidate ? AutovalidateMode.onUserInteraction : null,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 139, 1)),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onChanged: onChanged,
          onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
          validator: validator,
        ),
      ),
    );
  }
}

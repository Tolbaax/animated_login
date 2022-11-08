import 'package:flutter/material.dart';

class DefaultTextFormFiled extends StatelessWidget {
  final bool obscureText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String? label;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  const DefaultTextFormFiled({
    Key? key,
    this.obscureText = false,
    this.inputType = TextInputType.emailAddress,
    this.validator,
    this.label,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      focusNode: focusNode,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: label,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.blue, width: 1.25),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

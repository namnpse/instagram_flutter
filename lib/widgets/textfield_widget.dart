import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final Function(String)? onChanged;
  final Function()? onTapPostfixIcon;

  TextFieldWidget({
    this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.obscureText = false,
    this.onChanged,
    this.onTapPostfixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: mediumBlue,
      style: const TextStyle(
        color: mediumBlue,
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: mediumBlue),
        focusColor: mediumBlue,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: mediumBlue),
        ),
        labelText: hintText,
        prefixIcon: prefixIconData != null ? Icon(
          prefixIconData,
          size: 18,
          color: mediumBlue,
        ) : null,
        suffixIcon: GestureDetector(
          onTap: () {
            onTapPostfixIcon?.call();
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: mediumBlue,
          ),
        ),
      ),
    );
  }
}
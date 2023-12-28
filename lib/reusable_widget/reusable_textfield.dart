import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obSecure;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String label;
  final Widget? sufIcon;
  final Widget? preIcon;
  final bool isMulti;
  final bool enable;

  const ReusableTextField(
      {super.key,
      this.controller,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.obSecure = false,
      this.isMulti = false,
        this.enable = false,
      this.errorText,
      required this.label,
      this.sufIcon,
      this.preIcon,
      this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 7,
      ),
      child: TextFormField(
          onChanged: onChanged,
          obscureText: obSecure,
          keyboardType: keyboardType,
          controller: controller,
          maxLines: isMulti ? 5 : 1,
          enabled: enable,
          decoration: InputDecoration(
              prefixIcon: preIcon,
              suffixIcon: sufIcon,
              labelText: label,
              labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
              fillColor: Colors.white.withOpacity(0.9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(width: 1, style: BorderStyle.none),
              )),
          validator: validator),
    );
  }
}
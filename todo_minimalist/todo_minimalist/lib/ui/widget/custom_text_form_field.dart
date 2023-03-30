import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    this.obscureText = false,
    this.maxLines = 1,
    required this.icon,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmit,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final int maxLines;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final Function(String)? onSubmit;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: TextFormField(
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.primary),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.primary),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          readOnly: readOnly,
          onSaved: (value) {
            controller.text = value!;
          },
          onFieldSubmitted: onSubmit,
        ));
  }
}

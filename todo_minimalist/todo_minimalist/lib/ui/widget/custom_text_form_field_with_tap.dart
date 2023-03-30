import 'package:flutter/material.dart';

class CustomTextFormFieldWithTap extends StatelessWidget {
  const CustomTextFormFieldWithTap({
    required this.controller,
    required this.onTap,
    required this.prefixIcon,
    Key? key,
  }) : super(key: key);
  final TextEditingController controller;
  final Function()? onTap;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      keyboardType: TextInputType.text,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
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
    );
  }
}

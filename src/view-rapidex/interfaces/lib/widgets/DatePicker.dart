import 'package:flutter/material.dart';
import 'package:interfaces/widgets/CustomTextField.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final Function() onTap;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'Data de Nascimento',
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';

class DropdownTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback? onTap;

  const DropdownTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

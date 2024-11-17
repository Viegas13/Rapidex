import 'package:flutter/material.dart';

class ImageLabelField extends StatelessWidget {
  final String label;
  final String hint;
  final VoidCallback onAttachPressed;

  const ImageLabelField({
    super.key,
    required this.label,
    required this.hint,
    required this.onAttachPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: const TextStyle(color: Colors.grey),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: onAttachPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

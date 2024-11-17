import 'package:flutter/material.dart';

class DropdownTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final List<String> items;
  final ValueChanged<String>? onItemSelected;

  const DropdownTextField({
    Key? key,
    required this.controller,
    required this.labelText,

    this.onTap,

    required this.items,
    this.onItemSelected,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Exibe o bottom sheet com a lista de itens
        final selectedValue = await showModalBottomSheet<String>(
          context: context,
          builder: (BuildContext context) {
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    Navigator.pop(context, items[index]);
                  },
                );
              },
            );
          },
        );

        // Atualiza o campo de texto com o item selecionado
        if (selectedValue != null && onItemSelected != null) {
          onItemSelected!(selectedValue);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: labelText,
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
    );
  }
}

import 'package:flutter/material.dart';

class AutoCompleteTextInput extends StatelessWidget {
  const AutoCompleteTextInput({
    super.key,
    required this.items,
    required this.labelText,
    required this.filtred,
  });

  final List<String> items;
  final String labelText;
  final void Function(String) filtred;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return items.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          // Ação ao selecionar um item
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Você selecionou: $selection')),
          );
        },
        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: labelText,
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => filtred(text),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AutoCompleteTextInput extends StatefulWidget {
  AutoCompleteTextInput({
    super.key,
    required this.items,
    required this.labelText,
    required this.filtered,
    required this.onChanged,
    required this.onChangedViewMode,
    this.canChangeViewMode = true,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<bool> onChangedViewMode;
  bool? canChangeViewMode;
  final List<String> items;
  final String labelText;
  final void Function(String) filtered;

  @override
  State<AutoCompleteTextInput> createState() => _AutoCompleteTextInputState();
}

class _AutoCompleteTextInputState extends State<AutoCompleteTextInput> {
  var filteredItems = <String>[];
  String? selected = '';
  bool viewOnMap = false;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return widget.items.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        FocusScope.of(context).unfocus();
        setState(() {
          selected = selection;
        });
        widget.filtered(selection);
      },
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: "Pesquisar por academia",
            border: OutlineInputBorder(),
            suffixIcon: widget.canChangeViewMode == false
                ? null
                : IconButton(
                    onPressed: () {
                      setState(() {
                        viewOnMap = !viewOnMap;
                      });
                      widget.onChangedViewMode(viewOnMap);
                    },
                    icon: Icon(viewOnMap == false ? Icons.map_outlined : Icons.list_alt_outlined),
                  ),
          ),
          onChanged: (text) => widget.filtered(text),
          onSubmitted: (text) {
            focusNode.unfocus();
          },
          onTapOutside: (action) {
            focusNode.unfocus();
          },
        );
      },
    );
  }
}

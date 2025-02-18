import 'package:flutter/material.dart';

class GroupedSelection extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const GroupedSelection({
    super.key,
    required this.title,
    required this.children,
  });
  @override
  _GroupedSelectionState createState() => _GroupedSelectionState();
}

class _GroupedSelectionState extends State<GroupedSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        ...widget.children,
      ],
    );
  }
}

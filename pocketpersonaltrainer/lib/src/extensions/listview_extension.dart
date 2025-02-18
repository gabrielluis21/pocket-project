import 'package:flutter/material.dart';

extension AdvancedGroupedListExtension on List<MapEntry<String, List<Widget>>> {
  List<Widget> buildAdvancedGroupedList({
    required Widget Function(MapEntry<String, List<Widget>> group) groupTitleBuilder,
    required Widget Function(Widget item, IconData icon) itemBuilder,
  }) {
    return this.expand((group) {
      // Aqui associamos cada item com um ícone específico
      IconData icon;
      if (group.key == 'Grupo 1') {
        icon = Icons.star;
      } else if (group.key == 'Grupo 2') {
        icon = Icons.circle;
      } else {
        icon = Icons.square;
      }
      return [
        groupTitleBuilder(group),
        ...group.value.map((item) => itemBuilder(item, icon)),
        Divider(),
      ];
    }).toList();
  }
}

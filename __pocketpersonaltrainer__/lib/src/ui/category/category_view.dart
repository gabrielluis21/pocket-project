import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/category_controller.dart';
import 'package:pocketpersonaltrainer/src/ui/category/widgets/category_tile.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  String? get tag => 'categories';

  @override
  Widget build(BuildContext context) {
    controller.loadAll();
    return Obx(() {
      if (controller.categories.isNotEmpty) {
        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) => CategoryTile(
            category: controller.categories[index],
          ),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 15),
          ),
        );
      } else {
        return const Center(
          child: FlareActor(
            'assets/animations/WeightSpin.flr',
            animation: 'Spin',
          ),
        );
      }
    });
  }
}

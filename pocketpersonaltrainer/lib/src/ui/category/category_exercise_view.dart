// ignore_for_file: file_names

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/controllers/exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/mixings/purchase_mixin.dart';
import 'package:pocketpersonaltrainer/src/ui/category/widgets/category_exercise_tile.dart';
import 'package:pocketpersonaltrainer/src/widgets/ads/custom_ads.dart';

class CategoryExercisePage extends StatefulWidget {
  const CategoryExercisePage({
    super.key,
    required this.id,
    required this.categoryTitle,
    required this.language,
  });

  final String categoryTitle;
  final String id;
  final String language;

  @override
  State<CategoryExercisePage> createState() => _CategoryExercisePageState();
}

class _CategoryExercisePageState extends State<CategoryExercisePage> with PremiumFeaturesMixin {
  bool viewInGrid = false;
  final controller = Get.find<ExerciseController>(tag: 'exercise');
  late int positionOfAds;

  @override
  void initState() {
    controller.allExercises.clear();
    controller.loadAll(widget.id);
    positionOfAds = controller.allExercises.length ~/ 2;
    super.initState();
    //initSettingsController(Get.find<SettingsController>(tag: 'settings'));
  }

  _chouseViewMode() => setState(() {
        this.viewInGrid = !viewInGrid;
      });

  Widget _buildGridView() {
    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 0,
            crossAxisSpacing: 10,
            children: controller.allExercises
                .map(
                  (element) => CategoryExerciseTile(
                    language: widget.language,
                    isIngrid: this.viewInGrid,
                    exercise: element,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Expanded(
        child: SizedBox(
      child: ListView.builder(
          itemCount: controller.allExercises.length,
          itemBuilder: (context, index) {
            if (controller.allExercises.isNotEmpty) {
              if (index == positionOfAds) {
                return Visibility(
                  visible: purchaseController.isPremium.value == false,
                  child: CustomAds(isSmall: true),
                );
              }
              int adjustedIndex = index < positionOfAds ? index : index - 1;
              controller.allExercises[adjustedIndex].category = widget.categoryTitle;
              return CategoryExerciseTile(
                isIngrid: this.viewInGrid,
                exercise: controller.allExercises[adjustedIndex],
                language: widget.language,
              );
            } else {
              return const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: FlareActor(
                    'assets/animations/WeightSpin.flr',
                    animation: 'Spin',
                  ),
                ),
              );
            }
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(widget.categoryTitle),
        ),
        body: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Card(
                  shadowColor: Colors.transparent,
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Mostrar em:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        IconButton(
                          onPressed: _chouseViewMode,
                          icon: Icon(
                            MdiIcons.viewGrid,
                          ),
                          iconSize: 16,
                        ),
                        IconButton(
                          onPressed: _chouseViewMode,
                          icon: Icon(
                            MdiIcons.viewList,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              this.viewInGrid ? _buildGridView() : _buildListView(),
            ],
          ),
        ),
      ),
    );
  }
}

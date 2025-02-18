import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_exercise_view.dart';
import '../../../data/models/category_model.dart';

class CategoryTile extends StatelessWidget {
  CategoryTile({
    Key? key,
    this.category,
  }) : super(key: key);

  final CategoryModel? category;

  String language = '';

  Widget buildTitle() {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        language = 'en';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
      case AppLanguages.ES:
        language = 'es';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
      case AppLanguages.FR:
        language = 'fr';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
      case AppLanguages.CH:
        language = 'ch';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
      case AppLanguages.DE:
        language = 'de';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
      default:
        language = 'pt-br';
        return Text(
          category?.title?[language],
          style: AppTextTheme.theme.headlineSmall?.copyWith(
            color: AppColorTheme().customLightColorScheme.primary,
          ),
        );
    }
  }

  ImageProvider buildIcon() {
    if (category != null && category?.icon != '') {
      return NetworkImage(category!.icon!);
    } else {
      return const AssetImage("assets/images/empty.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: buildIcon(),
      ),
      title: buildTitle(),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoryExercisePage(
            language: language,
            id: category!.id!,
            categoryTitle: category?.title?[language],
          ),
        ));
      },
    );
  }
}

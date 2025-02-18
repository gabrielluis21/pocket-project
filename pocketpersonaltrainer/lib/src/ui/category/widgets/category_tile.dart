import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/ui/category/category_exercise_view.dart';
import '../../../data/models/category_model.dart';

class CategoryTile extends StatelessWidget {
  CategoryTile({
    super.key,
    this.category,
  });

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: category!.icon!,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Image.asset("assets/images/empty.png"),
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          radius: 30.0,
          backgroundColor: Colors.transparent,
        ),
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

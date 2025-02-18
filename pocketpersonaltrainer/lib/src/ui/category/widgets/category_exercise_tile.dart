import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/ui/exercise/exercise_view.dart';

class CategoryExerciseTile extends StatefulWidget {
  final ExerciseModel exercise;
  final bool isIngrid;
  final String language;
  const CategoryExerciseTile({
    super.key,
    required this.exercise,
    required this.isIngrid,
    required this.language,
  });

  @override
  State<CategoryExerciseTile> createState() => _CategoryExerciseTileState();
}

class _CategoryExerciseTileState extends State<CategoryExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: widget.isIngrid
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(widget.exercise.name?[widget.language]),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: widget.exercise.images![widget.language]!.first,
                            fit: BoxFit.cover,
                            height: 100.0,
                            errorWidget: (context, url, error) => Image.asset("assets/images/empty.png"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: widget.exercise.images!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.exercise.images![widget.language]!.first,
                            fit: BoxFit.cover,
                            height: 100.0,
                            errorWidget: (context, url, error) => Image.asset("assets/images/empty.png"),
                          )
                        : Image.asset("assets/images/empty.png"),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.exercise.name?[widget.language],
                            style: AppTextTheme.theme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExerciseScreen(
                  exercise: widget.exercise,
                  language: widget.language,
                )));
      },
    );
  }
}

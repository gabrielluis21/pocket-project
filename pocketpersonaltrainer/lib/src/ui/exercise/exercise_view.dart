import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/services/notefication_services.dart';
import 'package:pocketpersonaltrainer/src/ui/animations/animated_button.dart';
import 'package:pocketpersonaltrainer/src/ui/exercise/widgets/exercise_forms.dart';
import 'package:pocketpersonaltrainer/src/ui/exercise/widgets/exercise_image_details.dart';

class ExerciseScreen extends StatefulWidget {
  final ExerciseModel exercise;
  final String language;

  const ExerciseScreen({super.key, required this.exercise, required this.language});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> with SingleTickerProviderStateMixin {
  late DateTime date;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final userExercise = UserExercises();
  final quant = TextEditingController();
  final chooseDate = TextEditingController();
  final carouselController = CarouselController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    print(widget.exercise.toMap());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        addExerciseToUserList();
        _scheduleNotification();
        _controller.reverse();
      }
    });
  }

  List<Widget> buildImageList() {
    return List<Widget>.from(
      growable: false,
      widget.exercise.images?[widget.language]?.map((e) {
        print(e);
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ExerciseImageDetails(
                    exerciseImage: e,
                    exerciseName: widget.exercise.name![widget.language],
                  ))),
          child: CachedNetworkImage(
            height: 400,
            imageUrl: e,
            fit: BoxFit.fill,
            placeholder: (context, url) => const FlareActor(
              'assets/animations/WeightSpin.flr',
              fit: BoxFit.cover,
              animation: 'Spin',
            ),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/empty.png",
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
    );
  }

  String _buildParagraph(String text) {
    return text.split(r'*').join('\n\n');
  }

  Widget buildTitle() {
    return Text(
      widget.language != '' ? widget.exercise.name![widget.language] : '',
      softWrap: true,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget buildDescription() {
    return Text(
      widget.language != '' ? widget.exercise.name![widget.language] : '',
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.bodySmall,
      softWrap: true,
    );
  }

  Widget buildMuscleFocus() {
    return Text(
      widget.language != '' ? _buildParagraph(widget.exercise.foco?.isNotEmpty == true ? widget.exercise.foco![widget.language] : '') : '',
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      softWrap: true,
    );
  }

  _scheduleNotification() {
    var notifyServices = Get.find<NotificationServices>();
    notifyServices.createScheduleNotification(date);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.exercise.name?[widget.language],
            softWrap: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ), //Text(widget.exercise.name),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  top: 0,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 350,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: buildImageList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: buildTitle(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Text(
                            widget.exercise.description?[widget.language] ?? '',
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodySmall,
                            softWrap: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 10),
                          child: Align(alignment: Alignment.centerLeft, child: buildMuscleFocus()),
                        ),
                        const Divider(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 115,
                  child: ExerciseForms(
                    dataEscolhida: date,
                    chooseDate: chooseDate,
                    quant: quant,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.bottomCenter,
                  child: AnimatedButton(
                    controller: _controller,
                    text: AppLocalizations.of(context)!.addExercicioButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addExerciseToUserList() async {
    print(widget.exercise.toMap());
    userExercise.categoryExercise = widget.exercise.category;
    userExercise.exerciseId = widget.exercise.id;
    userExercise.isDone = false;
    userExercise.quantity = int.tryParse(quant.text);

    final stringToDate = chooseDate.text.split('/');
    print(stringToDate);
    userExercise.dateMarked = date;

    userExercise.exerciseData = widget.exercise;

    if (userExercise.dateMarked == null || quant.text.isEmpty) {
      Get.snackbar(
        "Erro ao Salvar",
        "Erro ao Salvar exercício!",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      );
    } else {
      print(userExercise.toMap());
      await Get.find<UserExercisesController>(tag: 'user_exercises').saveExercise(userExercise);
    }
  }
}

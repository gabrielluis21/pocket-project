import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/widgets/painter/custom_timer_painter.dart';

class TimerScreen extends StatefulWidget {
  final UserExercises exercise;

  const TimerScreen({super.key, required this.exercise});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController controller;

  final player = AudioPlayer();

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.exercise.quantity!),
    );
  }

  Future<int> stopAudio() async {
    AudioPlayer audio = AudioPlayer();
    final state = audio.state;
    if (state == PlayerState.stopped) {
      widget.exercise.isDone = true;
      widget.exercise.doneIn = DateTime.now();
      Get.find<UserExercisesController>().updateUserExercise(widget.exercise);

      Navigator.of(context).pop();
    }
    return 0;
  }

  Widget buildTitle() {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        return Text(
          widget.exercise.exerciseData?.name?['en'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
      case AppLanguages.ES:
        return Text(
          widget.exercise.exerciseData?.name?['es'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
      case AppLanguages.FR:
        return Text(
          widget.exercise.exerciseData?.name?['fr'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
      case AppLanguages.CH:
        return Text(
          widget.exercise.exerciseData?.name?['zh'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
      case AppLanguages.DE:
        return Text(
          widget.exercise.exerciseData?.name?['de'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
      default:
        return Text(
          widget.exercise.exerciseData?.name?['pt-br'],
          style: TextStyle(fontSize: 25.0, color: Colors.amber[900]),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: themeData.primaryColor,
                      height: controller.value * MediaQuery.of(context).size.height,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                      animation: controller,
                                      backgroundColor: Colors.white,
                                      color: themeData.indicatorColor,
                                    )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        buildTitle(),
                                        Text(
                                          timerString,
                                          style: const TextStyle(fontSize: 112.0, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                            animation: controller,
                            builder: (context, child) {
                              return FloatingActionButton.extended(
                                  onPressed: () {
                                    if (controller.isAnimating) {
                                      controller.stop();
                                    } else {
                                      controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value).whenComplete(() {
                                        player.play(DeviceFileSource('alarm.mp3')).timeout(const Duration(microseconds: 5), onTimeout: stopAudio);
                                        Get.find<UserExercisesController>().updateUserExercise(widget.exercise);
                                      });
                                    }
                                  },
                                  icon: Icon(controller.isAnimating ? Icons.pause : Icons.play_arrow),
                                  label: Text(controller.isAnimating ? "Pause" : "Play"));
                            }),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

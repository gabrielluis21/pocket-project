import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/app/app_pages.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/user_exercises_controller.dart';
import 'package:pocketpersonaltrainer/src/data/models/exercise_model.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_exercise.dart';
import 'package:pocketpersonaltrainer/src/data/models/user_model.dart';
import 'package:pocketpersonaltrainer/src/ui/to-do/todo_list_view.dart';
import 'package:table_calendar/table_calendar.dart';

class UserExerciseList extends StatefulWidget {
  const UserExerciseList({
    super.key,
    required this.pageContrller,
    required this.currentUser,
  });
  final UserModel currentUser;
  final PageController pageContrller;

  @override
  State<UserExerciseList> createState() => _UserExerciseListState();
}

class _UserExerciseListState extends State<UserExerciseList> {
  final userExerciseController = Get.find<UserExercisesController>(tag: "user_exercises");
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String language = '';

  @override
  void initState() {
    _selectedDay = _focusedDay;
    userExerciseController.loadAll();

    super.initState();
  }

  Widget _buildTitle(ExerciseModel? item) {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        language = 'en';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
      case AppLanguages.ES:
        language = 'es';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
      case AppLanguages.FR:
        language = 'fr';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
      case AppLanguages.CH:
        language = 'ch';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
      case AppLanguages.DE:
        language = 'de';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
      default:
        language = 'pt-br';
        return Text(
          item?.name?[language],
          style: AppTextTheme.theme.headlineSmall,
        );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      userExerciseController.getExercisesForDay(selectedDay);
    }
  }

  Widget _buildUeserExercisesList() {
    if (userExerciseController.myExercises.isEmpty) {
      return ListTile(
        trailing: Icon(MdiIcons.plus),
        onTap: () {
          widget.pageContrller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        title: Text(
          'Que tal começar um novo treino?',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: userExerciseController.myExercises.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: userExerciseController.myExercises[index].isDone == true ? Colors.green : Colors.red,
                border: Border.all(),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                onTap: () {
                  Get.to(
                      ToDoListScreen(
                        currentUSer: widget.currentUser,
                        controller: userExerciseController,
                        selectedDate: _selectedDay,
                      ),
                      routeName: Routes.TODO);
                },
                title: _buildTitle(userExerciseController.myExercises[index].exerciseData),
                trailing: userExerciseController.myExercises[index].isDone == true ? Icon(Icons.verified) : null,
              ),
            );
          },
        ),
      );
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      userExerciseController.getExercisesForRange(start, end);
    } else if (start != null) {
      userExerciseController.getExercisesForDay(start);
    } else if (end != null) {
      userExerciseController.getExercisesForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          TableCalendar<UserExercises>(
            headerStyle: HeaderStyle(
                decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            )),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.primary),
              weekdayStyle: TextStyle(fontSize: 16.0),
            ),
            rowHeight: 55,
            daysOfWeekHeight: 55,
            firstDay: DateTime.utc(1900, 01, 01),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay!, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: (value) {
              userExerciseController.getExercisesForDay(value);
              return userExerciseController.myExercises;
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 16.0),
              weekNumberTextStyle: TextStyle(fontSize: 16.0),
              weekendTextStyle: TextStyle(fontSize: 16.0),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            availableGestures: AvailableGestures.all,
            currentDay: DateTime.now(),
          ),
          _buildUeserExercisesList(),
        ],
      ),
    );
    /* return ; */
  }
}

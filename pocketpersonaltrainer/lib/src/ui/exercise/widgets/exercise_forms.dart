import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';

class ExerciseForms extends StatefulWidget {
  ExerciseForms({super.key, required this.chooseDate, required this.quant, this.dataEscolhida});
  final TextEditingController chooseDate;
  final TextEditingController quant;
  late DateTime? dataEscolhida;

  @override
  _ExerciseFormsState createState() => _ExerciseFormsState();
}

class _ExerciseFormsState extends State<ExerciseForms> {
  var day;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: widget.chooseDate,
            cursorColor: AppColorTheme().customDarkColorScheme.primary,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.chooseDate,
              suffix: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                onPressed: () async {
                  final localizations = MaterialLocalizations.of(context);
                  widget.chooseDate.clear();
                  var picked = await showDatePicker(
                    context: context,
                    locale: Get.deviceLocale,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.parse("2000-01-01 00:00:00.00000"),
                    lastDate: DateTime(DateTime.now().year, DateTime.december, 31),
                  );
                  var timed = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (picked != null && timed != null) {
                    var pickedWithMask = "${localizations.formatCompactDate(picked)} ${localizations.formatTimeOfDay(timed)}";
                    setState(() {
                      widget.dataEscolhida = localizations.parseCompactDate(localizations.formatCompactDate(picked))!.add(Duration(hours: timed.hour, minutes: timed.minute));
                      widget.chooseDate.text = pickedWithMask;
                    });
                  }
                },
              ),
            ),
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            cursorColor: AppColorTheme().customDarkColorScheme.primary,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.chooseRepetions,
            ),
            controller: widget.quant,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

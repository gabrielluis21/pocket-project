import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pocketpersonaltrainer/src/app/app_language.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';

class ExerciseForms extends StatefulWidget {
  const ExerciseForms({Key? key, required this.chooseDate, required this.quant}) : super(key: key);
  final TextEditingController chooseDate;
  final TextEditingController quant;

  @override
  _ExerciseFormsState createState() => _ExerciseFormsState();
}

class _ExerciseFormsState extends State<ExerciseForms> {
  var day;

  @override
  initState() {
    day = _localeDateMask();
    super.initState();
  }

  MaskTextInputFormatter _localeDateMask() {
    switch (Get.deviceLocale?.languageCode) {
      case AppLanguages.EN:
        return MaskTextInputFormatter(mask: '####/##/##', filter: {"#": RegExp(r'[0-9]')});
      case AppLanguages.ES:
        return MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
      case AppLanguages.FR:
        return MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
      case AppLanguages.CH:
        return MaskTextInputFormatter(mask: '####年##月##日', filter: {"#": RegExp(r'[0-9]')});
      case AppLanguages.DE:
        return MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
      default:
        return MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
    }
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
                  widget.chooseDate.clear();
                  var picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse("2000-01-01 00:00:00.00000"),
                      lastDate: DateTime(DateTime.now().year, DateTime.december, 31));
                  if (picked != null) {
                    var pickedWithMask = day.maskText("${picked.day}${picked.month < 10 ? '0${picked.month}' : picked.month}${picked.year}");
                    setState(() {
                      widget.chooseDate.text = pickedWithMask;
                    });
                  }
                },
              ),
            ),
            keyboardType: TextInputType.datetime,
            inputFormatters: [day],
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

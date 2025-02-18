import 'package:flutter/material.dart'; /* 
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart'; */

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 189.0,
          width: 200.0,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/New_Logo.png"),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ), /* 
        Text(
          AppLocalizations.of(context)!.appTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColorTheme().customLightColorScheme.primary,
            fontSize: 24,
            fontFamily: 'Noto Sans SC',
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ), */
      ],
    );
  }
}

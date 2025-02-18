import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';

class RecoverPasswordButton extends StatelessWidget {
  const RecoverPasswordButton(
      {Key? key,
      required this.authController,
      required this.emailController,
      }
    ): super(key: key);

  final AuthController authController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          child: Text(
            AppLocalizations.of(context)!.recoverPassword,
            style: TextStyle(
              color: Color(0xFF031CFF),
              fontSize: 14,
              fontFamily: 'Noto Sans SC',
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: () {
            if (emailController.text.isEmpty) {
              Get.snackbar(AppLocalizations.of(context)!.porfavorMessage,
                  AppLocalizations.of(context)!.recoverPasswordErro,
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3));
            } else {
              Get.snackbar(AppLocalizations.of(context)!.porfavorMessage,
                  AppLocalizations.of(context)!.recoverPasswordSucesso,
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: const Duration(seconds: 3));
              authController.recoverPassword(emailController.text);
            }
          },
        ),
      ),
    );
  }
}

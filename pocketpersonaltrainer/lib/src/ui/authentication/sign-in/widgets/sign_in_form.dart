import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/utils/validations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key, this.formKey, this.emailController, this.senhaController});

  final GlobalKey<FormState>? formKey;
  final TextEditingController? emailController;
  final TextEditingController? senhaController;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColorTheme().customLightColorScheme.primary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      gapPadding: 5.0),
                  icon: Icon(
                    Icons.person,
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                  labelStyle: TextStyle(
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                  labelText: '${AppLocalizations.of(context)?.textFieldEmail}',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColorTheme().customLightColorScheme.primary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      gapPadding: 5.0)),
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailController,
              validator: Validations.validarEmail,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible == true ? Icon(FontAwesomeIcons.eyeLowVision) : Icon(FontAwesomeIcons.eye)),
                  icon: Icon(
                    Icons.lock,
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                  labelText: '${AppLocalizations.of(context)?.textFieldSenha}',
                  labelStyle: TextStyle(
                    color: AppColorTheme().customLightColorScheme.primary,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColorTheme().customLightColorScheme.primary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      gapPadding: 5.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColorTheme().customLightColorScheme.primary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      gapPadding: 5.0),
                ),
                obscureText: isVisible,
                controller: widget.senhaController,
                validator: Validations.validarSenha),
          ],
        ),
      ),
    );
  }
}

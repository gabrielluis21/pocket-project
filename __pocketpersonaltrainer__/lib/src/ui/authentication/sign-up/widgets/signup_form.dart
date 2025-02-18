// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/services/gps_service.dart';
import 'package:pocketpersonaltrainer/src/utils/validations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpForm extends StatefulWidget {
  SignUpForm({
    Key? key,
    required this.pos,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.cityController,
    required this.passwdController,
  }) : super(key: key);

  final Map<String, double?> pos;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController passwdController;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool? aggred = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 57,
              width: 357,
              child: TextFormField(
                controller: widget.nameController,
                decoration: InputDecoration(
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
                  labelText: AppLocalizations.of(context)!.textFieldNome,
                ),
                validator: Validations.validarNome,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 57,
              width: 357,
              child: TextFormField(
                controller: widget.addressController,
                decoration: InputDecoration(
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
                    suffix: IconButton(
                      iconSize: 24,
                      onPressed: () async {
                        var location = await GpsService.getLocation();
                        var address = await GpsService.getAddressByGeoCordinates(location?.longitude, location?.latitude);
                        setState(() {
                          widget.pos.addAll({
                            "longitude": location?.longitude,
                            "latitude": location?.latitude,
                          });
                          widget.addressController.text = "${address.streetAddress}, ${address.streetNumber}";
                          widget.cityController.text = "${address.city}";
                        });
                      },
                      icon: Icon(MdiIcons.mapMarker),
                    ),
                    labelText: AppLocalizations.of(context)!.textFieldEnder),
                validator: Validations.validarAddress,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 57,
              width: 357,
              child: TextFormField(
                controller: widget.cityController,
                decoration: InputDecoration(
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
                    labelText: AppLocalizations.of(context)!.textFieldCidade),
                validator: Validations.validarNome,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 57,
              width: 357,
              child: TextFormField(
                controller: widget.emailController,
                decoration: InputDecoration(
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
                  labelText: AppLocalizations.of(context)!.textFieldEmail,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validations.validarEmail,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 57,
              width: 357,
              child: TextFormField(
                controller: widget.passwdController,
                decoration: InputDecoration(
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
                    labelText: AppLocalizations.of(context)!.textFieldSenha),
                validator: Validations.validarSenha,
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 25,
              width: 357,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(text: "Ao se cadastrar você aceita os ", children: [
                          TextSpan(
                            text: "Termos de uso ",
                            style: TextStyle(
                              color: AppColorTheme().customLightColorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(text: "\n e com as "),
                          TextSpan(
                            text: "Politicas de privacidade",
                            style: TextStyle(
                              color: AppColorTheme().customLightColorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ]),
                        style: TextStyle(
                          color: Color(0xFF031CFF),
                          fontSize: 12,
                          fontFamily: 'Noto Sans SC',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

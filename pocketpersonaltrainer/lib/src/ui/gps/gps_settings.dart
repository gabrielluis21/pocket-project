import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/utils/validations.dart';
import 'package:pocketpersonaltrainer/src/widgets/custom_list/group_selection.dart';

class GpsSettings extends StatelessWidget {
  GpsSettings({super.key});

  final gymNameController = TextEditingController();
  final gymContactController = TextEditingController();
  final personalNameController = TextEditingController();

  Future _sendMessageOnWhatsapp() async {
    var msg =
        "Olá, gostaria de pedir para que entre em contato com a minha academia: ${gymNameController.text}. \nFalar com: ${personalNameController.text} \nContato: ${gymContactController.text}";
    await launchUrl(Uri.parse('whatsapp://send?phone=+55 16 98120-2154&text=$msg'));
  }

  Future _sendEmail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    var msg =
        "Olá, gostaria de pedir para que entre em contato com a minha academia: ${gymNameController.text}. \nFalar com: ${personalNameController.text} \nContato: ${gymContactController.text}";

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'pocketpersonaltrainer.ppt.app@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Gostaria de indicar a minha academia!',
        'body': msg,
      }),
    );
    await launchUrl(emailLaunchUri);
  }

  _showOptionsDialog() {
    Get.dialog(AlertDialog.adaptive(
      icon: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.close),
      ),
      title: Text("Entre em contato com a gente"),
      actions: [
        ListTile(
          leading: Icon(FontAwesomeIcons.whatsapp),
          title: Text("WhatsApp"),
          onTap: () => _sendMessageOnWhatsapp(),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text("Email"),
          onTap: () => _sendEmail(),
        )
      ],
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 57,
                  width: 357,
                  child: TextFormField(
                    controller: gymNameController,
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
                      labelText: 'Nome da academia',
                    ),
                    validator: Validations.validarNome,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 57,
                  width: 357,
                  child: TextFormField(
                    controller: personalNameController,
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
                      labelText: 'Contato',
                    ),
                    validator: Validations.validarNome,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 57,
                  width: 357,
                  child: TextFormField(
                    controller: gymContactController,
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
                      labelText: 'Contato da academia',
                    ),
                    validator: Validations.validarNome,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar notificações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        physics: NeverScrollableScrollPhysics(),
        children: [
          GroupedSelection(
            title: 'Localização',
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.locationPin),
                title: Text(
                  "Altere as configurações de localização nativas do aparelho",
                  style: AppTextTheme.theme.bodyLarge,
                ),
                onTap: () => AppSettings.openAppSettings(type: AppSettingsType.location),
              ),
            ],
          ),
          GroupedSelection(
            title: 'Academias próximas',
            children: [
              ListTile(
                onTap: () {
                  Get.toNamed("/premium");
                },
                leading: Icon(FontAwesomeIcons.mapLocationDot),
                title: Text(
                  'Adquira nosso pacote de features para mostrar todas academias próximas de você',
                  style: AppTextTheme.theme.bodyLarge,
                ),
              ),
            ],
          ),
          GroupedSelection(
            title: 'Não encontrou a sua?',
            children: [
              ListTile(
                onTap: () => _showOptionsDialog(),
                leading: Icon(FontAwesomeIcons.message),
                title: Text(
                  'Entre em contato com a gente',
                  style: AppTextTheme.theme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

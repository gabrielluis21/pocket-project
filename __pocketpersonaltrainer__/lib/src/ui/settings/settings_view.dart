import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/app/theme/text_theme.dart';
import 'package:pocketpersonaltrainer/src/controllers/settings_controller.dart';
import 'package:pocketpersonaltrainer/src/extensions/listview_extension.dart';
import 'package:pocketpersonaltrainer/src/ui/notifications/notifications_settings_screen.dart';
import 'package:pocketpersonaltrainer/src/widgets/ads/custom_ads.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    final Map<String, List<Widget>> data = {
      'Tema': [
        ListTile(
          leading: Icon(settings.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Escolha o tema",
                style: AppTextTheme.theme.bodyLarge,
              ),
              Switch(
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  settings.updateThemeMode(value); // Alterna o tema ao trocar o switch
                },
              ),
            ],
          ),
        ),
      ],
      'Notificações': [
        ListTile(
          title: Text(
            "Configurar notificações",
            style: AppTextTheme.theme.bodyLarge,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationsSettingsScreen(),
              ),
            );
          },
        )
      ],
      'Mídia Social': [
        ListTile(
          onTap: () {},
          leading: Icon(FontAwesomeIcons.instagram),
          title: Text(
            'Siga-nos no Instagram',
          ),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(FontAwesomeIcons.facebook),
          title: Text(
            'Siga-nos no Facebook',
            style: AppTextTheme.theme.bodyLarge,
          ),
        ),
      ],
      'Mais configuraçõe': [
        ListTile(
          onTap: () {},
          leading: Icon(FontAwesomeIcons.googlePlay),
          title: Text(
            'Remova todos os anúncios',
            style: AppTextTheme.theme.bodyLarge,
          ),
        ),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: data.entries.toList().buildAdvancedGroupedList(
                          groupTitleBuilder: (group) => Text(
                            group.key,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          itemBuilder: (item, icon) => item,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: CustomAds(isSmall: true),
          ),
        ],
      ),
    );
  }
}

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/mixings/health_hint_mixing.dart';
import 'package:pocketpersonaltrainer/src/mixings/purchase_mixin.dart';
import 'package:pocketpersonaltrainer/src/services/notefication_services.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> with PremiumFeaturesMixin, HealthHintsMixin {
  late NotificationServices _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService = Get.find<NotificationServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar notificações'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Por padrão as notificações aparecerão a cada 3h desde o início do uso do app"),
          ),
          ListTile(
            title: Text("Agendar notificações no app"),
            subtitle: Text("Adiquera a versão premium, para desbloquear esta opção"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Configurar notificações no sistema"),
            onTap: () => AppSettings.openAppSettings(type: AppSettingsType.notification),
          ),
          ListTile(
            title: Text("Configurar dicas rápidas de saúde"),
            subtitle: Text("Dicas automáticas a cada $intervaloAtual horas."),
            onTap: () => ajustarIntervalo(context, purchaseController.isPremium.value),
          )
        ],
      ),
    );
  }
}

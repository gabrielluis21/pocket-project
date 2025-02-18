import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketpersonaltrainer/src/services/notefication_services.dart';
import 'package:pocketpersonaltrainer/src/ui/notifications/widgets/notification_scheduler.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
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
      body: NotificationScheduler(
        scheduleNotification: _notificationService.createScheduleNotification,
      ),
    );
  }
}

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pocketpersonaltrainer/src/controllers/auth_controller.dart';

class NotificationServices {
  NotificationServices._();

  factory NotificationServices() => _instance;
  static final NotificationServices _instance = NotificationServices._();
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
  static ReceivePort? receivePort;

  /// while creating channel do not mistake for creating channel key or not confusing with channel key create same channel key and use for notification
  /// one more thing prevent with null value or like null string because it will be giving error like native java null pointer exception so be care full
  /// while passing a data or creating a notification..

  Future<void> configuration() async {
    print("configuration check with this");
    await awesomeNotifications.initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'scheduled_channel',
          channelKey: 'scheduled',
          channelName: 'Pocket Personal Trainer - agendamentos',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          channelDescription: 'Notification channel for Pocket Personal Trainer',
          vibrationPattern: lowVibrationPattern,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
          enableLights: true,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          defaultPrivacy: NotificationPrivacy.Public,
        ),
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Pocket Personal Trainer',
          defaultColor: Colors.teal,
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          channelDescription: 'Notification channel for Pocket Personal Trainer',
          vibrationPattern: lowVibrationPattern,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
          enableLights: true,
          enableVibration: true,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          defaultPrivacy: NotificationPrivacy.Public,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'ppt_group',
          channelGroupName: 'PockerPersonalTrainerGroup',
        )
      ],
    );
  }

  Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')..listen((silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on main isolate
    IsolateNameServer.registerPortWithName(receivePort!.sendPort, 'notification_action_port');
  }

  void checkingPermissionNotification(BuildContext context) {
    print("checking permission");
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content: const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications().requestPermissionToSendNotifications().then((value) {
                    Navigator.of(context).pop();
                  }),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> createLocalInstantNotification() async {
    await awesomeNotifications.createNotification(
      content: NotificationContent(
          id: -1,
          channelKey: 'high_importance_channel',
          title: 'Você tem exercicios para fazer',
          body: "Corra, você consegue completar a sua lista de exercicios!",
          hideLargeIconOnExpand: false,
          largeIcon: "assets://assets/images/New_Logo.png",
          bigPicture: "assets://assets/images/New_Logo.png",
          notificationLayout: NotificationLayout.BigPicture,
          payload: {'notificationId': '1234567890'}),
    );
  }

  Future<void> jsonDataNotification(Map<String, Object> jsonData) async {
    await awesomeNotifications.createNotificationFromJsonData(jsonData);
  }

  Future<void> createScheduleNotification(DateTime? datePicked) async {
    try {
      if (datePicked == null && datePicked.isBlank == true) {
        await awesomeNotifications.createNotification(
          schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(days: 1)),
            repeats: true,
            preciseAlarm: true,
            allowWhileIdle: true,
          ),
          content: NotificationContent(
            id: 0,
            channelKey: 'scheduled',
            title: 'Você tem exercicios para fazer',
            body: "Corra, você consegue completar a sua lista de exercicios!",
            hideLargeIconOnExpand: false,
            largeIcon: "asstes/images/New_Logo.png",
            bigPicture: "asstes/images/New_Logo.png",
            notificationLayout: NotificationLayout.BigPicture,
          ),
        );
      } else {
        await awesomeNotifications.createNotification(
          schedule: NotificationCalendar(
            day: datePicked?.day,
            month: datePicked?.month,
            year: datePicked?.year,
            hour: datePicked?.hour,
            minute: datePicked?.minute,
            timeZone: datePicked?.timeZoneName,
            preciseAlarm: true,
            allowWhileIdle: true,
          ),
          content: NotificationContent(
            id: 0,
            channelKey: 'scheduled',
            title: 'Você tem exercicios para fazer',
            body: "Corra, você consegue completar a sua lista de exercicios!",
            hideLargeIconOnExpand: false,
            largeIcon: "asstes/images/New_Logo.png",
            bigPicture: "asstes/images/New_Logo.png",
            notificationLayout: NotificationLayout.BigPicture,
            criticalAlert: true,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> createCustomNotificationWithActionButtons() async {
    await awesomeNotifications.createNotification(
        content: NotificationContent(
            id: -1,
            channelKey: 'pocketpersonsltrainer',
            title: 'Buy Favorite Product',
            body: "Hurry Up To Grab This Product Loot With Just 80% Off",
            largeIcon: "asstes/images/New_Logo.png",
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'fazerAgora', label: 'Fazer Agora'),
          NotificationActionButton(key: 'maisTarde', label: 'Mais Tarde'),
        ]);
  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction || receivedAction.actionType == ActionType.SilentBackgroundAction) {
      // For background actions, you must hold the execution until the end
      print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    } else {
      // this process is only necessary when you need to redirect the user
      // to a new page or use a valid context, since parallel isolates do not
      // have valid context, so you need redirect the execution to main isolate
      if (receivePort == null) {
        print('onActionReceivedMethod was called inside a parallel dart isolate.');
        SendPort? sendPort = IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          print('Redirecting the execution to main isolate process.');
          sendPort.send(receivedAction);
          return;
        }
      }
      print("check data with receivedAction 3$receivedAction");

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> onActionReceivedImplementationMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyInput == "fazerAgora") {
    } else if (receivedAction.buttonKeyInput == "maisTarde") {
    } else {
      final authC = Get.find<AuthController>();
      print(authC.currentUser.user?.toMap());
    }
  }

  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  Future<void> startListeningNotificationEvents() async {
    print("check data with start listing");
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod);
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    print("onNotificationCreatedMethod");

    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
    print("onNotificationDisplayedMethod");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
    print("onDismissActionReceivedMethod");
  }
}

import 'package:flutter/material.dart';

class NotificationScheduler extends StatefulWidget {
  final Future<void> Function(bool?, DateTime?) scheduleNotification;

  const NotificationScheduler({super.key, required this.scheduleNotification});

  @override
  _NotificationSchedulerState createState() => _NotificationSchedulerState();
}

class _NotificationSchedulerState extends State<NotificationScheduler> {
  TimeOfDay? selectedTime;
  bool notifyOnWeekends = false;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _schedule() {
    if (selectedTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      widget.scheduleNotification(notifyOnWeekends, scheduledTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: Text('Escolha a Hora da Notificação'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: notifyOnWeekends,
              onChanged: (value) {
                setState(() {
                  notifyOnWeekends = value!;
                });
              },
            ),
            Text('Notificar nos finais de semana'),
          ],
        ),
        ElevatedButton(
          onPressed: _schedule,
          child: Text('Agendar Notificação'),
        ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          importance: Importance.max),
    );
  }

  static Future init({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    // if (initSchedule) {
    //   tz.initializeTimeZones();
    //   final locationName = await FlutterNativeTimezone.getLocalTimezone();
    //   tz.setLocalLocation(tz.getLocation(locationName));
    // }
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,

  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        // tz.TZDateTime.from(scheduleDate, tz.local),
        _scheduleDaily(Time()),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate =
        tz.TZDateTime(tz.local, time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }
}

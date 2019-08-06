import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    var time = new Time(17, 58, 0);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('your other channel id', 'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.cancelAll();
    flutterLocalNotificationsPlugin.showDailyAtTime(
        0, 'show daily title', 'Daily notification shown at approximately ${time.hour}:${time.minute}:${time.second}', time, platformChannelSpecifics);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(
            Icons.menu,
            size: 35.0,
            color: AppThemes.GREY,
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          DemoLocalizations.of(context).notifications,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
      ),
      body: Center(child: Text('Notificaciones')),
    );
  }
}

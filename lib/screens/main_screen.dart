import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/screens/add_weight_screen.dart';
import 'package:simple_weight_tracking_app/screens/drawer_screen.dart';
import 'package:simple_weight_tracking_app/screens/stepper_screen.dart';
import 'package:simple_weight_tracking_app/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Weight> weights = [];
  FirebaseUser _user;
  InfoUser _infoUser;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) async {
    print('Hola');
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => SelectWeightScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    weights.clear();
    return _user == null
        ? LoadingIndicator()
        : StreamBuilder<Object>(
            stream: Firestore.instance.collection('userInfo').document(_user.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot1) {
              if (snapshot1.connectionState != ConnectionState.active) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  backgroundColor: AppThemes.BLACK_BLUE,
                );
              }
              if (snapshot1.data.data == null) {
                return StepperScreen(_user);
              } else {
                _infoUser = InfoUser.fromJson(snapshot1.data.data);
              }
              return StreamBuilder(
                stream: Firestore.instance.collection('weights').document(_user.uid).snapshots(),
                builder: ((context, AsyncSnapshot snapshot2) {
                  if (snapshot2.connectionState != ConnectionState.active) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      backgroundColor: AppThemes.BLACK_BLUE,
                    );
                  }
                  Map<String, dynamic> map = Map<String, dynamic>.from(snapshot2.data.data);
                  ListWeight listSnapshot = ListWeight.fromJson(map);
                  weights = listSnapshot.weights;
                  weights.sort((w1, w2) => w1.date.compareTo(w2.date));

                  return DrawerScreen(
                    user: _user,
                    infoUser: _infoUser,
                    auth: _auth,
                    weights: weights,
                  );
                }),
              );
            },
          );
  }

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    _auth.currentUser().then((FirebaseUser user) {
      setState(() {
        _user = user;
      });
    });
    super.initState();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class SettingsScreen extends StatefulWidget {
  final FirebaseUser user;
  final InfoUser infoUser;

  SettingsScreen({this.infoUser, this.user});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget bottomButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              color: AppThemes.CYAN,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Text(
                  DemoLocalizations.of(context).saveSettings.toUpperCase(),
                  style: TextStyle(letterSpacing: 3.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                DocumentReference userInfoRef = Firestore.instance.collection("userInfo").document(widget.user.uid);
                Firestore.instance.runTransaction((transaction) async {
                  await transaction.set(userInfoRef, widget.infoUser.toJson());
                }).catchError((e) {
                  Flushbar(
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                    borderColor: Colors.black,
                    backgroundColor: Colors.red,
                    messageText: Text(
                      DemoLocalizations.of(context).undefinedError,
                      style: TextStyle(color: AppThemes.BLACK_BLUE),
                    ),
                    duration: Duration(seconds: 3),
                  ).show(context);
                });
              },
            ),
          ),
        ],
      );
    }

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
          automaticallyImplyLeading: false,
          title: Text(
            DemoLocalizations.of(context).settings,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        bottomNavigationBar: bottomButton(),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: widget.infoUser.retardedUnits ? AppThemes.CYAN : Colors.transparent,
                        border: Border.all(color: widget.infoUser.retardedUnits ? AppThemes.CYAN : Colors.white),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      DemoLocalizations.of(context).imperial.toUpperCase(),
                      style: TextStyle(color: widget.infoUser.retardedUnits ? AppThemes.BLACK_BLUE : AppThemes.CYAN, fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      widget.infoUser.retardedUnits = true;
                    });
                  },
                ),
                InkWell(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: !widget.infoUser.retardedUnits ? AppThemes.CYAN : Colors.transparent,
                        border: Border.all(color: !widget.infoUser.retardedUnits ? AppThemes.CYAN : Colors.white),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      DemoLocalizations.of(context).metric.toUpperCase(),
                      style: TextStyle(color: !widget.infoUser.retardedUnits ? AppThemes.BLACK_BLUE : AppThemes.CYAN, fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      widget.infoUser.retardedUnits = false;
                    });
                  },
                ),
              ],
            )));
  }
}

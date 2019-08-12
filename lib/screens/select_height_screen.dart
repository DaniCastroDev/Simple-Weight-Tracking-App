import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/utils/units.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class HeightScreen extends StatefulWidget {
  final FirebaseUser user;
  final InfoUser infoUser;

  HeightScreen({this.infoUser, this.user});

  @override
  _HeightScreenState createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
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
                  DemoLocalizations.of(context).saveHeight.toUpperCase(),
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
            DemoLocalizations.of(context).height,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        bottomNavigationBar: bottomButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${getCorrectHeight(widget.infoUser.retardedUnits, widget.infoUser.height)}' ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7.0),
                            child: Text(
                              widget.infoUser.height != null ? widget.infoUser.retardedUnits ? '' : 'cm' : '',
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          widget.infoUser.retardedUnits
                              ? Text(
                                  '${widget.infoUser.height.toStringAsFixed(0)}' ?? '',
                                  style: TextStyle(color: AppThemes.GREY, fontSize: 20.0, fontWeight: FontWeight.bold),
                                )
                              : Container(),
                          widget.infoUser.retardedUnits
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    widget.infoUser.height != null ? 'cm' : '',
                                    style: TextStyle(color: AppThemes.GREY, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/plain-logo.png',
                      width: widget.infoUser.height * 1.2,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 0,
                child: Container(
                  width: 80.0,
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: WeightSlider(
                    controller: ScrollController(),
                    minValue: 1,
                    maxValue: 300,
                    isHeight: true,
                    width: MediaQuery.of(context).size.height / 1.4,
                    value: widget.infoUser.height,
                    onChanged: (value) {
                      setState(() {
                        widget.infoUser.height = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

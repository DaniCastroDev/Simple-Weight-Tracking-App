import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/utils/units.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class GoalsScreen extends StatefulWidget {
  final InfoUser infoUser;
  final FirebaseUser user;
  GoalsScreen({this.infoUser, this.user});

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
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
                  DemoLocalizations.of(context).updateGoals.toUpperCase(),
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            DemoLocalizations.of(context).objectives,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          actions: <Widget>[
            Checkbox(
              value: widget.infoUser.activeObjectives,
              onChanged: (value) {
                setState(() {
                  widget.infoUser.activeObjectives = value;
                });
              },
              checkColor: AppThemes.BLACK_BLUE,
              activeColor: AppThemes.CYAN,
            ),
          ],
        ),
        bottomNavigationBar: bottomButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            DemoLocalizations.of(context).initialWeight,
                            style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Card(
                          color: AppThemes.GREY_GREENER,
                          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${getValueFromDBWeightAsDouble(widget.infoUser.retardedUnits, widget.infoUser.initialWeight)}' ?? '',
                                          style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 7.0),
                                          child: Text(
                                            widget.infoUser.initialWeight != null ? getUnitOfMeasure(widget.infoUser.retardedUnits) : '',
                                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: TextEditingController(
                                                text: DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(widget.infoUser.dateInitialWeight)),
                                            style: TextStyle(fontSize: 24.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: DemoLocalizations.of(context).email,
                                              filled: true,
                                              fillColor: AppThemes.CYAN,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext builder) {
                                                  return Container(
                                                      height: MediaQuery.of(context).copyWith().size.height / 3.5,
                                                      child: CupertinoDatePicker(
                                                        initialDateTime: widget.infoUser.dateInitialWeight,
                                                        onDateTimeChanged: (DateTime newdate) {
                                                          setState(() {
                                                            widget.infoUser.dateInitialWeight = newdate;
                                                            DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(widget.infoUser.dateInitialWeight);
                                                          });
                                                        },
                                                        maximumDate: new DateTime.now(),
                                                        minimumYear: 1900,
                                                        maximumYear: DateTime.now().year,
                                                        mode: CupertinoDatePickerMode.date,
                                                      ));
                                                });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 100.0,
                                  child: WeightSlider(
                                    controller: ScrollController(),
                                    minValue: 1,
                                    maxValue: 1000,
                                    width: MediaQuery.of(context).size.width - 50,
                                    value: getValueFromDBWeightAsDouble(widget.infoUser.retardedUnits, widget.infoUser.initialWeight),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.infoUser.initialWeight = getValueToDBWeightAsDouble(widget.infoUser.retardedUnits, value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            DemoLocalizations.of(context).objectiveWeight,
                            style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Card(
                          color: AppThemes.GREY_GREENER,
                          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${getValueFromDBWeightAsDouble(widget.infoUser.retardedUnits, widget.infoUser.objectiveWeight)}' ?? '',
                                          style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 7.0),
                                          child: Text(
                                            widget.infoUser.objectiveWeight != null ? getUnitOfMeasure(widget.infoUser.retardedUnits) : '',
                                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: TextEditingController(
                                                text: DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(widget.infoUser.dateObjectiveWeight)),
                                            style: TextStyle(fontSize: 24.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              hintText: DemoLocalizations.of(context).email,
                                              filled: true,
                                              fillColor: AppThemes.CYAN,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext builder) {
                                                  return Container(
                                                      height: MediaQuery.of(context).copyWith().size.height / 3.5,
                                                      child: CupertinoDatePicker(
                                                        initialDateTime: widget.infoUser.dateObjectiveWeight,
                                                        onDateTimeChanged: (DateTime newdate) {
                                                          setState(() {
                                                            widget.infoUser.dateObjectiveWeight = newdate;
                                                            DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(widget.infoUser.dateObjectiveWeight);
                                                          });
                                                        },
                                                        maximumDate: new DateTime.now(),
                                                        minimumYear: 1900,
                                                        mode: CupertinoDatePickerMode.date,
                                                      ));
                                                });
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 100.0,
                                  child: WeightSlider(
                                    controller: ScrollController(),
                                    minValue: 1,
                                    maxValue: 1000,
                                    width: MediaQuery.of(context).size.width - 50,
                                    value: getValueFromDBWeightAsDouble(widget.infoUser.retardedUnits, widget.infoUser.objectiveWeight),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.infoUser.objectiveWeight = getValueToDBWeightAsDouble(widget.infoUser.retardedUnits, value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.infoUser.activeObjectives
                  ? Container()
                  : AnimatedOpacity(
                      opacity: widget.infoUser.activeObjectives ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
                        color: AppThemes.BLACK_BLUE,
                        child: Center(
                            child: Text(
                          DemoLocalizations.of(context).goalsDisabled,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
                        )),
                      ),
                    ),
            ],
          ),
        ));
  }
}

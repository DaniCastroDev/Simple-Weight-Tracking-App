import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_page_form/multi_page_form.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';
import 'package:simple_weight_tracking_app/utils/units.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class StepperScreen extends StatefulWidget {
  final FirebaseUser user;

  const StepperScreen(this.user);
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  InfoUser infoUser = InfoUser(
    gender: 'F',
    dateInitialWeight: DateTime.now(),
    dateObjectiveWeight: DateTime.now().add(Duration(days: 14)),
    dateOfBirth: DateTime(2000),
    height: 160.0,
    initialWeight: 70.0,
    objectiveWeight: 70.0,
    activeObjectives: true,
    retardedUnits: false,
  );
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateOfBirth);

    return Scaffold(
      body: MultiPageForm(
        totalPage: 4,
        nextButtonStyle: Text(
          DemoLocalizations.of(context).next,
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        previousButtonStyle: Text(
          DemoLocalizations.of(context).previous,
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        submitButtonStyle: Text(
          DemoLocalizations.of(context).save,
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        pageList: <Widget>[sexAndBirth(), units(), height(), weights()],
        onFormSubmitted: () {
          DocumentReference userInfoRef = Firestore.instance.collection("userInfo").document(widget.user.uid);
          DocumentReference weightsRef = Firestore.instance.collection("weights").document(widget.user.uid);

          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(userInfoRef, infoUser.toJson());
            await transaction.set(weightsRef, ListWeight([Weight(onlyDate(DateTime.now()), infoUser.initialWeight)]).toJson());
          });
        },
      ),
    );
  }

  Widget sexAndBirth() {
    String getGender(String gender) {
      switch (gender) {
        case 'M':
          return DemoLocalizations.of(context).male;
          break;
        case 'F':
          return DemoLocalizations.of(context).female;
          break;
        case 'O':
          return DemoLocalizations.of(context).other;
          break;
        default:
          return '';
      }
    }

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      DemoLocalizations.of(context).birthdate,
                      style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _controller,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.date_range,
                                color: AppThemes.CYAN,
                                size: 70.0,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                      height: MediaQuery.of(context).copyWith().size.height / 3.5,
                                      child: CupertinoDatePicker(
                                        initialDateTime: infoUser.dateOfBirth,
                                        onDateTimeChanged: (DateTime newdate) {
                                          setState(() {
                                            infoUser.dateOfBirth = newdate;
                                            _controller.text = DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateOfBirth);
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
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          DemoLocalizations.of(context).sex,
                          style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          getGender(infoUser.gender),
                          style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GridView(
                        primary: false,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 25.0, mainAxisSpacing: 25.0),
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: infoUser.gender == 'F' ? AppThemes.CYAN : Colors.transparent,
                                  border: Border.all(color: infoUser.gender == 'F' ? AppThemes.CYAN : Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                FontAwesomeIcons.venus,
                                size: 100.0,
                                color: Colors.pink,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                infoUser.gender = 'F';
                              });
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: infoUser.gender == 'M' ? AppThemes.CYAN : Colors.transparent,
                                  border: Border.all(color: infoUser.gender == 'M' ? AppThemes.CYAN : Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                FontAwesomeIcons.mars,
                                size: 100.0,
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                infoUser.gender = 'M';
                              });
                            },
                          ),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  color: infoUser.gender == 'O' ? AppThemes.CYAN : Colors.transparent,
                                  border: Border.all(color: infoUser.gender == 'O' ? AppThemes.CYAN : Colors.white),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Icon(
                                FontAwesomeIcons.marsStrokeH,
                                size: 100.0,
                                color: Colors.yellow,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                infoUser.gender = 'O';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget units() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          DemoLocalizations.of(context).settings,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: infoUser.retardedUnits ? AppThemes.CYAN : Colors.transparent,
                      border: Border.all(color: infoUser.retardedUnits ? AppThemes.CYAN : Colors.white),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    DemoLocalizations.of(context).imperial.toUpperCase(),
                    style: TextStyle(color: infoUser.retardedUnits ? AppThemes.BLACK_BLUE : AppThemes.CYAN, fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  setState(() {
                    infoUser.retardedUnits = true;
                  });
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: !infoUser.retardedUnits ? AppThemes.CYAN : Colors.transparent,
                      border: Border.all(color: infoUser.retardedUnits ? AppThemes.CYAN : Colors.white),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    DemoLocalizations.of(context).metric.toUpperCase(),
                    style: TextStyle(color: !infoUser.retardedUnits ? AppThemes.BLACK_BLUE : AppThemes.CYAN, fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                onTap: () {
                  setState(() {
                    infoUser.retardedUnits = false;
                  });
                },
              ),
            ],
          )),
    );
  }

  Widget height() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            DemoLocalizations.of(context).height,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
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
                            '${getCorrectHeight(infoUser.retardedUnits, infoUser.height)}' ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7.0),
                            child: Text(
                              infoUser.height != null ? infoUser.retardedUnits ? '' : 'cm' : '',
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          infoUser.retardedUnits
                              ? Text(
                                  '${infoUser.height.toStringAsFixed(0)}' ?? '',
                                  style: TextStyle(color: AppThemes.GREY, fontSize: 20.0, fontWeight: FontWeight.bold),
                                )
                              : Container(),
                          infoUser.retardedUnits
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(
                                    infoUser.height != null ? 'cm' : '',
                                    style: TextStyle(color: AppThemes.GREY, fontSize: 10.0, fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/plain-logo.png',
                      width: infoUser.height * 1.2,
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
                    value: infoUser.height,
                    onChanged: (value) {
                      setState(() {
                        infoUser.height = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget weights() {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            DemoLocalizations.of(context).objectives,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          actions: <Widget>[
            Checkbox(
              value: infoUser.activeObjectives,
              onChanged: (value) {
                setState(() {
                  infoUser.activeObjectives = value;
                });
              },
              checkColor: AppThemes.BLACK_BLUE,
              activeColor: AppThemes.CYAN,
            ),
          ],
        ),
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
                                          '${getValueFromDBWeightAsDouble(infoUser.retardedUnits, infoUser.initialWeight)}' ?? '',
                                          style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 7.0),
                                          child: Text(
                                            infoUser.initialWeight != null ? getUnitOfMeasure(infoUser.retardedUnits) : '',
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
                                            controller:
                                                TextEditingController(text: DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateInitialWeight)),
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
                                                        initialDateTime: infoUser.dateInitialWeight,
                                                        onDateTimeChanged: (DateTime newdate) {
                                                          setState(() {
                                                            infoUser.dateInitialWeight = newdate;
                                                            DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateInitialWeight);
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
                                    width: MediaQuery.of(context).size.width,
                                    value: getValueFromDBWeightAsDouble(infoUser.retardedUnits, infoUser.initialWeight),
                                    onChanged: (value) {
                                      setState(() {
                                        infoUser.initialWeight = getValueToDBWeightAsDouble(infoUser.retardedUnits, value);
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
                                          '${getValueFromDBWeightAsDouble(infoUser.retardedUnits, infoUser.objectiveWeight)}' ?? '',
                                          style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 7.0),
                                          child: Text(
                                            infoUser.initialWeight != null ? getUnitOfMeasure(infoUser.retardedUnits) : '',
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
                                                text: DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateObjectiveWeight)),
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
                                                        initialDateTime: infoUser.dateObjectiveWeight,
                                                        onDateTimeChanged: (DateTime newdate) {
                                                          setState(() {
                                                            infoUser.dateObjectiveWeight = newdate;
                                                            DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateObjectiveWeight);
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
                                    width: MediaQuery.of(context).size.width,
                                    value: getValueFromDBWeightAsDouble(infoUser.retardedUnits, infoUser.objectiveWeight),
                                    onChanged: (value) {
                                      setState(() {
                                        infoUser.objectiveWeight = getValueToDBWeightAsDouble(infoUser.retardedUnits, value);
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
              infoUser.activeObjectives
                  ? Container()
                  : Container(
                      color: AppThemes.BLACK_BLUE,
                      child: Center(
                          child: Text(
                        DemoLocalizations.of(context).goalsDisabled,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
                      )),
                    ),
            ],
          ),
        ));
  }
}

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
  );
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = DateFormat.yMMMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateOfBirth);

    return Scaffold(
      body: MultiPageForm(
        totalPage: 3,
        nextButtonStyle: Text(
          'Siguiente',
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        previousButtonStyle: Text(
          'Anterior',
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        submitButtonStyle: Text(
          'Guardar',
          style: TextStyle(fontSize: 20.0, color: AppThemes.CYAN, fontWeight: FontWeight.bold),
        ),
        pageList: <Widget>[sexAndBirth(), height(), weights()],
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
                              size: 50.0,
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
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20.0, mainAxisSpacing: 20.0),
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
                              size: 150.0,
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
                              size: 150.0,
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
                              size: 150.0,
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
    ));
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
                            '${infoUser.height.toInt()}' ?? '',
                            style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7.0),
                            child: Text(
                              height != null ? 'cm' : '',
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
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
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      DemoLocalizations.of(context).initialWeight,
                      style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${infoUser.initialWeight}' ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          infoUser.initialWeight != null ? 'kg' : '',
                          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0,
              child: WeightSlider(
                minValue: 1,
                maxValue: 500,
                width: MediaQuery.of(context).size.width,
                value: infoUser.initialWeight,
                onChanged: (value) {
                  setState(() {
                    infoUser.initialWeight = value;
                  });
                },
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      DemoLocalizations.of(context).objectiveWeight,
                      style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${infoUser.objectiveWeight}' ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.0),
                        child: Text(
                          infoUser.objectiveWeight != null ? 'kg' : '',
                          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 100.0,
              child: WeightSlider(
                minValue: 1,
                maxValue: 500,
                width: MediaQuery.of(context).size.width,
                value: infoUser.objectiveWeight,
                onChanged: (value) {
                  setState(() {
                    infoUser.objectiveWeight = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

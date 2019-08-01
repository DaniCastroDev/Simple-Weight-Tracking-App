import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_page_form/multi_page_form.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class StepperScreen extends StatefulWidget {
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  String _sex = 'F';
  DateTime _birthdate = DateTime(2000);
  double _height = 170.0;
  double _initialWeight = 70.0;
  double _objectiveWeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiPageForm(
        totalPage: 5,
        nextButtonStyle: Text(
          'Siguiente',
          style: TextStyle(color: AppThemes.CYAN),
        ),
        previousButtonStyle: Text(
          'Anterior',
          style: TextStyle(color: AppThemes.CYAN),
        ),
        submitButtonStyle: Text(
          'Guardar',
          style: TextStyle(color: AppThemes.CYAN),
        ),
        pageList: <Widget>[sex(), age(), height(), page4(), page5()],
        onFormSubmitted: () {
          print("Form is submitted");
        },
      ),
    );
  }

  Widget sex() {
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DemoLocalizations.of(context).sex,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                getGender(_sex),
                style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Column(
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
                                color: _sex == 'F' ? AppThemes.CYAN : Colors.transparent,
                                border: Border.all(color: _sex == 'F' ? AppThemes.CYAN : Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(
                              FontAwesomeIcons.venus,
                              size: 150.0,
                              color: Colors.pink,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _sex = 'F';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: _sex == 'M' ? AppThemes.CYAN : Colors.transparent,
                                border: Border.all(color: _sex == 'M' ? AppThemes.CYAN : Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(
                              FontAwesomeIcons.mars,
                              size: 150.0,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _sex = 'M';
                            });
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: _sex == 'O' ? AppThemes.CYAN : Colors.transparent,
                                border: Border.all(color: _sex == 'O' ? AppThemes.CYAN : Colors.white),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Icon(
                              FontAwesomeIcons.marsStrokeH,
                              size: 150.0,
                              color: Colors.yellow,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _sex = 'O';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget age() {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Seleccione su fecha de nacimiento",
              style: TextStyle(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateFormat.yMMMMd(DemoLocalizations.of(context).locale.languageCode).format(_birthdate),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
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
                              initialDateTime: _birthdate,
                              onDateTimeChanged: (DateTime newdate) {
                                setState(() {
                                  _birthdate = newdate;
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
    ));
  }

  Widget height() {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Altura'),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
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
                      DemoLocalizations.of(context).height,
                      style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${_height.toInt()}' ?? '',
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
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: WeightSlider(
                minValue: 1,
                maxValue: 300,
                isHeight: true,
                width: MediaQuery.of(context).size.height,
                value: _height,
                onChanged: (value) {
                  setState(() {
                    _height = value;
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget page4() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Peso inicial'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Text('SEXO'),
      ),
    );
  }

  Widget page5() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Peso objetivo'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Text('SEXO'),
      ),
    );
  }
}

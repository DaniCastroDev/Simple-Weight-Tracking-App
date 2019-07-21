import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/utils/sharedprefs_constants.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences prefs;
  double initialWeight;
  double objectiveWeight;
  double height;
  bool isRetardUnits;
  @override
  Widget build(BuildContext context) {
    return prefs == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            backgroundColor: AppThemes.BLACK_BLUE,
            body: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: AppThemes.BLACK_BLUE,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Ajustes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
              ),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop(true)),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              color: AppThemes.CYAN,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                child: Text(
                  'GUARDAR AJUSTES',
                  style: TextStyle(letterSpacing: 3.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () => _saveSettings(context),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: _changeUnits,
                        shape: OutlineInputBorder(borderSide: BorderSide(color: !isRetardUnits ? Colors.transparent : AppThemes.CYAN)),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            'METRIC\nSYSTEM',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isRetardUnits ? Colors.white : AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                        ),
                        color: isRetardUnits ? Colors.transparent : AppThemes.CYAN,
                      ),
                      FlatButton(
                        onPressed: _changeUnits,
                        shape: OutlineInputBorder(borderSide: BorderSide(color: isRetardUnits ? Colors.transparent : AppThemes.CYAN)),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            'IMPERIAL\nSYSTEM',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: !isRetardUnits ? Colors.white : AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold, fontSize: 15.0),
                          ),
                        ),
                        color: !isRetardUnits ? Colors.transparent : AppThemes.CYAN,
                      ),
                    ],
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            'Altura',
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${height.toInt()}' ?? '',
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
                    height: 100.0,
                    child: WeightSlider(
                      minValue: 1,
                      maxValue: 300,
                      isHeight: true,
                      width: MediaQuery.of(context).size.width,
                      value: height,
                      onChanged: (value) {
                        setState(() {
                          height = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            'Peso inicial',
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '$initialWeight' ?? '',
                              style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: Text(
                                initialWeight != null ? 'kg' : '',
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
                      value: initialWeight,
                      onChanged: (value) {
                        setState(() {
                          initialWeight = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 7.0),
                          child: Text(
                            'Peso objetivo',
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '$objectiveWeight' ?? '',
                              style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7.0),
                              child: Text(
                                objectiveWeight != null ? 'kg' : '',
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
                      value: objectiveWeight,
                      onChanged: (value) {
                        setState(() {
                          objectiveWeight = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _changeUnits() {
    setState(() {
      isRetardUnits = !isRetardUnits;
    });
  }

  _saveSettings(context) {
    prefs.setBool(RETARD_SYSTEM, isRetardUnits);
    prefs.setDouble(HEIGHT, height);
    prefs.setDouble(INITIAL_WEIGHT, initialWeight);
    prefs.setDouble(OBJECTIVE_WEIGHT, objectiveWeight);
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((_instance) {
      setState(() {
        prefs = _instance;
        height = prefs.getDouble(HEIGHT) ?? 160.0;
        objectiveWeight = prefs.getDouble(OBJECTIVE_WEIGHT) ?? 60;
        initialWeight = prefs.getDouble(INITIAL_WEIGHT) ?? 80;
        isRetardUnits = prefs.getBool(RETARD_SYSTEM) ?? false;
      });
    });
    super.initState();
  }
}

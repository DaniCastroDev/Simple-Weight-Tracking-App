import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectWeightScreen extends StatefulWidget {
  @override
  _SelectWeightScreenState createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {
  double weight;
  SharedPreferences prefs;
  static const String LIST_WEIGHTS = "weights";
  double currentWeight;
  List<String> sharedValues = [];
  List<Weight> weights = [];
  Map<DateTime, double> values;
  DateTime date = DateTime.now();
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
                  'Añadir peso',
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
                  'GUARDAR',
                  style: TextStyle(letterSpacing: 3.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () => _addWeight(context),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: AppThemes.GREY_GREENER,
                    child: TableCalendar(
                        availableCalendarFormats: {CalendarFormat.month: 'Month'},
                        endDay: DateTime.now(),
                        calendarStyle: CalendarStyle(
                          selectedColor: AppThemes.CYAN,
                          selectedStyle: TextStyle(color: Colors.black),
                          weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          weekendStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          unavailableStyle: TextStyle(color: AppThemes.GREY, fontWeight: FontWeight.bold),
                          outsideDaysVisible: false,
                          todayColor: AppThemes.GREEN_GREYER,
                          todayStyle: TextStyle(color: Colors.black),
                        ),
                        headerStyle: HeaderStyle(
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: AppThemes.GREY,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: AppThemes.GREY,
                          ),
                          centerHeaderTitle: true,
                          titleTextStyle: TextStyle(color: AppThemes.GREY, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          dowTextBuilder: (DateTime date, locale) {
                            return DateFormat('E').format(date).substring(0, 1);
                          },
                          weekdayStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                          weekendStyle: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                        onDaySelected: _changeDay),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$weight' ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 60.0, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11.0),
                      child: Text(
                        weight != null ? 'kg' : '',
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100.0,
                  child: WeightSlider(
                    minValue: 1,
                    maxValue: 500,
                    width: MediaQuery.of(context).size.width,
                    value: weight,
                    onChanged: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
  }

  _changeDay(DateTime datetime, _) {
    setState(() {
      print('CHANGED DATE TO ${datetime.day} / ${datetime.month}');
      DateTime _onlyDate = onlyDate(datetime);
      date = _onlyDate;
      if (values.containsKey(_onlyDate)) {
        weight = values[_onlyDate];
      }
    });
  }

  _addWeight(context) {
    List<Weight> toRemoveList = [];
    Weight _myWeight = Weight(weight, date, difference: weight - currentWeight);

    weights.forEach((_weight) {
      if (areEqualDates(_myWeight.dateTime, _weight.dateTime)) toRemoveList.add(_weight);
    });
    toRemoveList.forEach((_weight) {
      print('Removed item ${_weight.dateTime} - ${_weight.weight}');
      weights.remove(_weight);
      sharedValues.remove(jsonEncode(_weight));
    });
    setState(() {
      print('Added item ${_myWeight.dateTime} - ${_myWeight.weight}');
      weights.add(_myWeight);
      sharedValues.add(jsonEncode(_myWeight));
      prefs.setStringList(LIST_WEIGHTS, sharedValues);
      currentWeight = weights.last.weight;
    });
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((_instance) {
      setState(() {
        prefs = _instance;
        sharedValues = prefs.getStringList(LIST_WEIGHTS) ?? [];
        sharedValues.forEach((_weight) {
          weights.add(Weight.fromJson(jsonDecode(_weight)));
        });
        values = Map.fromIterable(weights, key: (item) => onlyDate(item.dateTime), value: (item) => item.weight);
        currentWeight = weights.isNotEmpty ? weights.last.weight : 60.0;
        weight = currentWeight;
      });
    });
    super.initState();
  }
}

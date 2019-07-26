import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/weights.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';
import 'package:simple_weight_tracking_app/widgets/weight_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectWeightScreen extends StatefulWidget {
  @override
  _SelectWeightScreenState createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {
  double weight = 60;
  MyDatabase db;
  double currentWeight;
  List<Weight> weights = [];
  Map<DateTime, double> values;
  DateTime date = onlyDate(DateTime.now());
  Map<DateTime, List> events;
  @override
  Widget build(BuildContext context) {
    values = Map.fromIterable(weights, key: (w) => (w as Weight).date, value: (w) => (w as Weight).weight);
    events = Map.fromIterable(weights, key: (item) => (item as Weight).date, value: (item) => [item]);

    return Scaffold(
      backgroundColor: AppThemes.BLACK_BLUE,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DemoLocalizations.of(context).addWeight,
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
            DemoLocalizations.of(context).save.toUpperCase(),
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
                  locale: DemoLocalizations.of(context).locale.languageCode,
                  availableCalendarFormats: {CalendarFormat.month: 'Month'},
                  endDay: DateTime.now(),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                    selectedColor: AppThemes.CYAN,
                    selectedStyle: TextStyle(color: Colors.black),
                    weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    unavailableStyle: TextStyle(color: AppThemes.GREY, fontWeight: FontWeight.bold),
                    markersMaxAmount: 1,
                    markersAlignment: Alignment.center,
                    markersColor: AppThemes.CYAN,
                    markersPositionBottom: 7.0,
                    outsideDaysVisible: false,
                    todayColor: AppThemes.GREEN_GREYER,
                    todayStyle: TextStyle(color: Colors.black),
                  ),
                  events: events,
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
                      return DateFormat('E', 'es').format(date).substring(0, 1).toUpperCase();
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

  /// Método que actualiza el día seleccionado y actualiza el valor del picker.

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

  /// Añade el peso a la base de datos.
  /// Si el peso ya existe, lo actualizamos.
  /// Si el peso no existe, lo añadimos.
  /// El peso existe cuando existe un registro en la misma fecha.

  _addWeight(context) {
    Weight _toAdd = Weight(date: date, weight: weight);
    if (weights != null && weights.firstWhere((w) => w.date.isAtSameMomentAs(date), orElse: () => null) != null) {
      print('Actualizamos el valor ${_toAdd.date}, ${_toAdd.weight}');
      db.updateWeight(_toAdd);
    } else {
      print('Añadimos el valor ${_toAdd.date}, ${_toAdd.weight}');
      db.addWeight(_toAdd);
    }
    Navigator.of(context).pop(true);
  }

  @override
  void initState() {
    print('INIT');
    db = MyDatabase();
    db.allWeightEntries.then((value) {
      setState(() {
        weights = value;
        weight = value.last.weight;
      });
    });
    super.initState();
  }
}

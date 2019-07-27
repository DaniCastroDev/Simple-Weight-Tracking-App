import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/weights.dart';
import 'package:simple_weight_tracking_app/utils/bmi.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';

enum Type { WEEKLY, MONTHLY, YEARLY }

class WeightChart extends StatefulWidget {
  final List<Weight> weights;
  final bool isRetardUnits;
  WeightChart(this.weights, this.isRetardUnits);

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  Type tableType = Type.WEEKLY;
  double maxValue = 0.0;
  double minValue = 1000.0;
  bool containsInitialDate = false;
  bool containsTodayDate = false;
  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    widget.weights.sort((w1, w2) => w1.date.compareTo(w2.date));

    void addSpots(int days) {
      DateTime today = onlyDate(DateTime.now());
      DateTime initialDay = today.subtract(Duration(days: days));
      List<FlSpot> flspots = [];
      widget.weights.forEach((weight) {
        if (weight.date.isAtSameMomentAs(initialDay.add(Duration(days: 1)))) containsInitialDate = true;
        if (weight.date.isAtSameMomentAs(today)) containsTodayDate = true;
        if (weight.date.isAfter(initialDay)) {
          Duration difference = initialDay.difference(onlyDate(weight.date));
          if (minValue > weight.weight) minValue = weight.weight;
          if (maxValue < weight.weight) maxValue = weight.weight;
          flspots.add(FlSpot(difference.inDays.abs().toDouble(), weight.weight));
        }
      });
      if (!containsInitialDate) spots.add(FlSpot(1, widget.weights.first.weight));
      flspots.forEach((_spot) {
        spots.add(_spot);
      });
      if (!containsTodayDate) spots.add(FlSpot(days.toDouble(), widget.weights.last.weight));
    }

    switch (tableType) {
      case Type.WEEKLY:
        addSpots(7);
        break;
      case Type.MONTHLY:
        addSpots(30);
        break;
      case Type.YEARLY:
        addSpots(365);
        break;
    }

    _changeTable(dynamic value) {
      setState(() {
        tableType = value;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: AppThemes.GREY))),
          child: DropdownButtonHideUnderline(
              child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              icon: Icon(Icons.keyboard_arrow_down),
              value: tableType,
              items: [
                DropdownMenuItem(
                    value: Type.WEEKLY,
                    child: Text(
                      DemoLocalizations.of(context).lastWeek,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    )),
                DropdownMenuItem(
                    value: Type.MONTHLY,
                    child: Text(
                      DemoLocalizations.of(context).lastMonth,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    )),
                DropdownMenuItem(
                    value: Type.YEARLY,
                    child: Text(
                      DemoLocalizations.of(context).lastYear,
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                    )),
              ],
              onChanged: _changeTable,
            ),
          )),
        ),
        Container(
          height: 15.0,
          width: 1.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          height: 200,
          child: FlChart(
            chart: LineChart(
              LineChartData(
                minY: minValue,
                maxY: maxValue + 1.0,
                borderData: FlBorderData(
                  show: false,
                ),
                lineBarsData: [
                  LineChartBarData(
                    curveSmoothness: 0.0,
                    isStrokeCapRound: true,
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    colors: [
                      AppThemes.CYAN,
                    ],
                    belowBarData: BelowBarData(
                      show: true,
                      colors: [
                        AppThemes.CYAN.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      gradientColorStops: [0.1, 1.0],
                      gradientFrom: Offset(0, 0),
                      gradientTo: Offset(0, 1),
                    ),
                    dotData: FlDotData(
                      show: true,
                      dotSize: 5.0,
                      dotColor: AppThemes.CYAN,
                      checkToShowDot: (value) {
                        int todayX;
                        switch (tableType) {
                          case Type.WEEKLY:
                            todayX = 7;
                            break;
                          case Type.MONTHLY:
                            todayX = 30;
                            break;
                          case Type.YEARLY:
                            todayX = 365;
                            return false;
                            break;
                        }
                        if (value.x == 1 && !containsInitialDate) return false;
                        if (value.x == todayX && !containsTodayDate) return false;
                        return true;
                      },
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  drawHorizontalGrid: true,
                  drawVerticalGrid: true,
                  getDrawingVerticalGridLine: (value) {
                    return const FlLine(
                      color: Colors.transparent,
                      strokeWidth: 1.0,
                    );
                  },
                  getDrawingHorizontalGridLine: (value) {
                    return const FlLine(
                      color: Colors.transparent,
                      strokeWidth: 45.0,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  getHorizontalTitles: (value) {
                    switch (tableType) {
                      case Type.WEEKLY:
                        return DateFormat('E', DemoLocalizations.of(context).locale.languageCode).format(DateTime.now().subtract(Duration(days: (6 - value).toInt())));
                        break;
                      case Type.MONTHLY:
                        if (value % 5 == 0)
                          return DateFormat('d/MM', DemoLocalizations.of(context).locale.languageCode).format(DateTime.now().subtract(Duration(days: (29 - value).toInt())));
                        return '';
                        break;
                      case Type.YEARLY:
                        if (value % 56 == 0)
                          return DateFormat('MMM', DemoLocalizations.of(context).locale.languageCode).format(DateTime.now().subtract(Duration(days: (365 - value).toInt())));
                        return '';
                        break;
                      default:
                        return '';
                    }
                  },
                  getVerticalTitles: (value) {
                    return widget.isRetardUnits ? '${kgToLb(value).toStringAsFixed(0)} lb' : '${value.toStringAsFixed(0)} kg';
                  },
                  horizontalTitlesTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  verticalTitlesTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  horizontalTitleMargin: 15.0,
                  verticalTitleMargin: 15.0,
                  verticalTitlesReservedWidth: 30.0,
                  showVerticalTitles: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    getSpots() {}
  }
}

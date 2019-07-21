import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/utils/bmi.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';

enum Type { WEEKLY, MONTHLY, YEARLY }

class WeightChart extends StatelessWidget {
  final List<Weight> weights;
  final Type type;
  final bool isRetardUnits;
  WeightChart(this.weights, this.type, this.isRetardUnits);

  @override
  Widget build(BuildContext context) {
    double maxValue = 0.0;
    double minValue = 1000.0;
    List<FlSpot> spots = [];
    weights.sort((w1, w2) => w1.dateTime.compareTo(w2.dateTime));
    switch (type) {
      case Type.WEEKLY:
        weights.forEach((weight) {
          DateTime initialDay = onlyDate(DateTime.now()).subtract(Duration(days: 6));
          if (weight.dateTime.isAfter(initialDay)) {
            Duration difference = initialDay.difference(onlyDate(weight.dateTime));
            if (minValue > weight.weight) minValue = weight.weight;
            if (maxValue < weight.weight) maxValue = weight.weight;
            spots.add(FlSpot(difference.inDays.abs().toDouble(), weight.weight));
          }
        });
        break;
      case Type.MONTHLY:
        weights.forEach((weight) {
          DateTime initialDay = onlyDate(DateTime.now()).subtract(Duration(days: 29));
          if (weight.dateTime.isAfter(initialDay)) {
            Duration difference = initialDay.difference(onlyDate(weight.dateTime));
            if (minValue > weight.weight) minValue = weight.weight;
            if (maxValue < weight.weight) maxValue = weight.weight;
            spots.add(FlSpot(difference.inDays.abs().toDouble(), weight.weight));
          }
        });
        break;
      case Type.YEARLY:
        weights.forEach((weight) {
          DateTime initialDay = onlyDate(DateTime.now()).subtract(Duration(days: 365));
          if (weight.dateTime.isAfter(initialDay)) {
            Duration difference = initialDay.difference(onlyDate(weight.dateTime));
            if (minValue > weight.weight) minValue = weight.weight;
            if (maxValue < weight.weight) maxValue = weight.weight;
            spots.add(FlSpot(difference.inDays.abs().toDouble(), weight.weight));
          }
        });
        break;
    }
    print('MINVALE: $minValue MAXVALUE: $maxValue');
    return SizedBox(
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
                curveSmoothness: 0.35,
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
//                  checkToShowDot: (value) {
//                    if (value.x == spots.length) return true;
//                    return false;
//                  },
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
                switch (type) {
                  case Type.WEEKLY:
                    return DateFormat('d/MM').format(DateTime.now().subtract(Duration(days: (6 - value).toInt())));
                    break;
                  case Type.MONTHLY:
                    if (value % 5 == 0 || value == 29 || value == 1) return DateFormat('d/MM').format(DateTime.now().subtract(Duration(days: (29 - value).toInt())));
                    return '';
                    break;
                  case Type.YEARLY:
                    if (value % 28 == 0) return DateFormat('MMM').format(DateTime.now().subtract(Duration(days: (365 - value).toInt())));
                    return '';
                    break;
                }
              },
              getVerticalTitles: (value) {
                return isRetardUnits ? '${kgToLb(value).toStringAsFixed(0)} lb' : '${value.toStringAsFixed(0)} kg';
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
    );
  }
}

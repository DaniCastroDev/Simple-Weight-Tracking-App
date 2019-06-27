import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';

Widget sample3(BuildContext context, List<Weight> weights) {
  final fromDate = DateTime(2019, 05, 22);
  final toDate = DateTime.now();

  List<DataPoint> points = [];
  weights.forEach((_weight) {
    points.add(DataPoint<DateTime>(value: _weight.weight, xAxis: _weight.dateTime));
  });

  return Center(
    child: Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: BezierChart(
        fromDate: fromDate,
        bezierChartScale: BezierChartScale.WEEKLY,
        toDate: toDate,
        selectedDate: toDate,
        series: [
          BezierLine(
            label: "KG",
            onMissingValue: (dateTime) {
              if (dateTime.day.isEven) {
                return 10.0;
              }
              return 5.0;
            },
            data: points,
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black,
          showVerticalIndicator: false,
          verticalIndicatorFixedPosition: false,
          backgroundColor: Colors.transparent,
          footerHeight: 30.0,
          pinchZoom: true,
          displayYAxis: true,
        ),
      ),
    ),
  );
}

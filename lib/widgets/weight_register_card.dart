import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';
import 'package:simple_weight_tracking_app/utils/units.dart';

class WeightRegisterCard extends StatelessWidget {
  final Weight weight;
  final double difference;
  final bool isRetarded;

  const WeightRegisterCard({Key key, this.weight, this.difference, this.isRetarded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color differenceColor;
    IconData icon;

    if (difference != null) {
      if (difference > 0) {
        icon = Icons.arrow_upward;
        differenceColor = Colors.red;
      } else if (difference < 0) {
        icon = Icons.arrow_downward;
        differenceColor = AppThemes.CYAN;
      } else {
        icon = Icons.arrow_forward;
        differenceColor = Colors.yellow;
      }
    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: AppThemes.GREY_GREENER,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${displayDate(context, weight.date)}',
                  style: TextStyle(color: AppThemes.GREY, fontSize: 14.0),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 30.0,
                    ),
                    icon != null ? Icon(icon, color: differenceColor) : Container(),
                    icon != null
                        ? Text(
                            '${getCorrectWeight(isRetarded, difference.abs())}${getUnitOfMeasure(isRetarded)}',
                            style: TextStyle(color: differenceColor, fontWeight: FontWeight.bold),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${getCorrectWeight(isRetarded, weight.weight)}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(
                    getUnitOfMeasure(isRetarded),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

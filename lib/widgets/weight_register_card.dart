import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/utils/dates.dart';

class WeightRegisterCard extends StatelessWidget {
  final Weight weight;

  const WeightRegisterCard({Key key, this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color difference;
    IconData icon;

    if (weight.difference != null) {
      if (weight.difference > 0) {
        icon = Icons.arrow_upward;
        difference = Colors.red;
      } else if (weight.difference < 0) {
        icon = Icons.arrow_downward;
        difference = AppThemes.CYAN;
      } else {
        icon = Icons.arrow_forward;
        difference = Colors.yellow;
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
                  '${displayDate(weight.dateTime)}',
                  style: TextStyle(color: AppThemes.GREY, fontSize: 14.0),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 30.0,
                    ),
                    icon != null ? Icon(icon, color: difference) : Container(),
                    icon != null
                        ? Text(
                            '${weight.difference.abs().toStringAsFixed(2)} kg',
                            style: TextStyle(color: difference, fontWeight: FontWeight.bold),
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
                  '${weight.weight}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    'kg',
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

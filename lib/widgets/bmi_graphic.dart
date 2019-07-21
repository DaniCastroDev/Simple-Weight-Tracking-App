import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/utils/bmi.dart';

class BMIGraphic extends StatelessWidget {
  final double ibm;

  const BMIGraphic({Key key, this.ibm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int initValue = 15;
    int endValue = 40;
    List<Container> containers = [];
    List<Widget> numbers = [];
    double valueWithoutDecimals = ibm.floorToDouble();
    double decimals = ibm - valueWithoutDecimals;
    double roundedIbm = decimals > 0.5 ? valueWithoutDecimals + 0.5 : valueWithoutDecimals;
    if (roundedIbm < 15) roundedIbm = 15;
    if (roundedIbm > 40) roundedIbm = 40;

    for (int i = 0; i < endValue - initValue; initValue++) {
      double valueRound = (initValue + i).toDouble();
      containers.add(Container(
        width: (roundedIbm == valueRound) ? 3.0 : 2.0,
        height: (roundedIbm == valueRound) ? 30.0 : 20.0,
        color: getColorByIBM(valueRound),
      ));
      double valueMiddle = initValue + i + 0.5;
      containers.add(Container(
        width: (roundedIbm == valueMiddle) ? 3.0 : 2.0,
        height: (roundedIbm == valueMiddle) ? 30.0 : 20.0,
        color: getColorByIBM(valueMiddle),
      ));
    }
    int _lastValue = initValue;
    fronteras.forEach((_frontera) {
      int flexValue = _frontera.toInt() - _lastValue;
      _lastValue = _frontera.toInt();
      numbers.add(Expanded(
        flex: flexValue,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_frontera.toStringAsFixed(_frontera.truncateToDouble() == _frontera ? 0 : 1)}',
            style: TextStyle(color: AppThemes.GREY),
          ),
        ),
      ));
    });
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: containers,
        ),
        Container(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: numbers,
        ),
      ],
    );
  }
}

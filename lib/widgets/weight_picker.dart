import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';

class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.width,
    @required this.value,
    @required this.onChanged,
    this.isHeight = false,
  }) : super(key: key);

  final double minValue;
  final double maxValue;
  final double width;
  final double value;
  final bool isHeight;
  final ValueChanged<double> onChanged;

  double get itemExtent => width / 20;

  double _indexToValue(int index) => minValue + (index - 1);
  @override
  build(BuildContext context) {
    print('RELOAD $value');
    ScrollController _controller = ScrollController(
        // No se por qué, funcionaba asi que no lo he tocado
        initialScrollOffset: isHeight
            ? ((MediaQuery.of(context).size.width / 20) * (value - 10)) - ((MediaQuery.of(context).size.width / 20) / 2) + ((MediaQuery.of(context).size.width / 20))
            : ((MediaQuery.of(context).size.width / 20) * (value - 1) * 10) - ((MediaQuery.of(context).size.width / 20) / 2) + ((MediaQuery.of(context).size.width / 20)));
    int itemCount = isHeight ? (maxValue - minValue).toInt() + 3 : ((maxValue - minValue) * 10).toInt() + 3;
    print('${_controller.initialScrollOffset}');
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemExtent: itemExtent,
        itemCount: itemCount,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final double builderValue = _indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
              ? Container() //empty first and last element
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment(0.0, 0.0),
                      children: <Widget>[
                        builderValue % 10 == 0
                            ? Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  color: isHeight ? value == builderValue ? AppThemes.CYAN : Colors.white : value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                                ),
                                height: isHeight ? value == builderValue ? 20 : 20 : value * 10 == builderValue ? 20 : 20,
                                width: isHeight ? value == builderValue ? 5 : 2 : value * 10 == builderValue ? 5 : 2,
                              )
                            : Container(
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  color: isHeight ? value == builderValue ? AppThemes.CYAN : Colors.white : value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                                ),
                                height: isHeight ? value == builderValue ? 20 : 10 : value * 10 == builderValue ? 20 : 10,
                                width: isHeight ? value == builderValue ? 5 : 1 : value * 10 == builderValue ? 5 : 1,
                              ),
                        Container(
                          color: Colors.white.withOpacity(0.05),
                          height: 1.0,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: builderValue % 10 == 0
                          ? Text(
                              isHeight ? '${builderValue.toInt()}' : '${builderValue ~/ 10}',
                              style: TextStyle(color: AppThemes.GREY, fontSize: isHeight ? builderValue.toInt() > 99 ? 11.0 : 14.0 : (builderValue ~/ 10) > 99 ? 11.0 : 14.0),
                            )
                          : Text(''),
                    ),
                  ],
                );
        },
      ),
    );
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  double _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    double middleValue = _indexToValue(indexOfMiddleElement);
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      double middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (middleValue != value) {
        onChanged(isHeight ? middleValue : middleValue / 10); //update selection
      }
    }
    return true;
  }
}

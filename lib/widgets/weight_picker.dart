import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';

class WeightSlider extends StatefulWidget {
  static _WeightSliderState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<_WeightSliderState>());
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.width,
    @required this.value,
    @required this.onChanged,
    @required this.controller,
    this.isHeight = false,
  }) : super(key: key);

  final double minValue;
  final double maxValue;
  final double width;
  final double value;
  final bool isHeight;
  final ValueChanged<double> onChanged;
  final ScrollController controller;
  double get initialOffset => isHeight ? (value * width / 15) - (width / 2) : ((width / 20) * (value - 1) * 10) - ((width / 20) / 2) + ((width / 20));
  @override
  _WeightSliderState createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  double get itemExtent => widget.isHeight ? widget.width / 15 : widget.width / 20;

  double _indexToValue(int index) => widget.minValue + (index - 1);

  @override
  void initState() {
    Timer(Duration(microseconds: 1), () => widget.controller.jumpTo(widget.initialOffset));
    super.initState();
  }

  @override
  build(BuildContext context) {
    int itemCount = widget.isHeight ? (widget.maxValue - widget.minValue).toInt() + 3 : ((widget.maxValue - widget.minValue) * 10).toInt() + 3;
    Widget _list = ListView.builder(
      shrinkWrap: true,
      controller: widget.controller,
      scrollDirection: widget.isHeight ? Axis.vertical : Axis.horizontal,
      reverse: widget.isHeight,
      itemExtent: itemExtent,
      itemCount: itemCount,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final double builderValue = _indexToValue(index);
        bool isExtra = index == 0 || index == itemCount - 1;

        return isExtra
            ? Container() //empty first and last element
            : widget.isHeight
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
//                      builderValue % 5 == 0
//                          ? Text(
//                              widget.isHeight ? '${builderValue.toInt()}' : '${builderValue ~/ 10}',
//                              style: TextStyle(color: AppThemes.GREY, fontSize: widget.isHeight ? 20.0 : (builderValue ~/ 10) > 99 ? 11.0 : 14.0),
//                            )
//                          : Text(''),
                      builderValue % 10 == 0
                          ? Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: widget.isHeight
                                    ? widget.value == builderValue ? AppThemes.CYAN : Colors.white
                                    : widget.value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                              ),
                              height: widget.isHeight ? widget.value == builderValue ? 5 : 2 : widget.value * 10 == builderValue ? 20 : 20,
                              width: widget.isHeight ? widget.value == builderValue ? 20 : 20 : widget.value * 10 == builderValue ? 5 : 2,
                            )
                          : Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: widget.isHeight
                                    ? widget.value == builderValue ? AppThemes.CYAN : Colors.white
                                    : widget.value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                              ),
                              height: widget.isHeight ? widget.value == builderValue ? 5 : 1 : widget.value * 10 == builderValue ? 20 : 10,
                              width: widget.isHeight ? widget.value == builderValue ? 20 : 10 : widget.value * 10 == builderValue ? 5 : 1,
                            ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      builderValue % 10 == 0
                          ? Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: widget.isHeight
                                    ? widget.value == builderValue ? AppThemes.CYAN : Colors.white
                                    : widget.value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                              ),
                              height: widget.isHeight ? widget.value == builderValue ? 5 : 2 : widget.value * 10 == builderValue ? 20 : 20,
                              width: widget.isHeight ? widget.value == builderValue ? 20 : 20 : widget.value * 10 == builderValue ? 5 : 2,
                            )
                          : Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: widget.isHeight
                                    ? widget.value == builderValue ? AppThemes.CYAN : Colors.white
                                    : widget.value * 10 == builderValue ? AppThemes.CYAN : Colors.white,
                              ),
                              height: widget.isHeight ? widget.value == builderValue ? 5 : 1 : widget.value * 10 == builderValue ? 20 : 10,
                              width: widget.isHeight ? widget.value == builderValue ? 20 : 10 : widget.value * 10 == builderValue ? 5 : 1,
                            ),
//                      Padding(
//                          padding: const EdgeInsets.only(top: 10.0),
//                          child: widget.isHeight
//                              ? builderValue % 5 == 0
//                                  ? Text(
//                                      widget.isHeight ? '${builderValue.toInt()}' : '${builderValue ~/ 10}',
//                                      style: TextStyle(
//                                          color: AppThemes.GREY, fontSize: widget.isHeight ? builderValue.toInt() > 99 ? 11.0 : 14.0 : (builderValue ~/ 10) > 99 ? 11.0 : 14.0),
//                                    )
//                                  : Text('')
//                              : builderValue % 10 == 0
//                                  ? Text(
//                                      widget.isHeight ? '${builderValue.toInt()}' : '${builderValue ~/ 10}',
//                                      style: TextStyle(
//                                          color: AppThemes.GREY, fontSize: widget.isHeight ? builderValue.toInt() > 99 ? 11.0 : 14.0 : (builderValue ~/ 10) > 99 ? 11.0 : 14.0),
//                                    )
//                                  : Text('')),
                    ],
                  );
      },
    );
    return NotificationListener(
      onNotification: _onNotification,
      child: _list,
    );
  }

  int _offsetToMiddleIndex(double offset) => (offset + widget.width / 2) ~/ itemExtent;

  double _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    double middleValue = _indexToValue(indexOfMiddleElement);
    return middleValue;
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      double middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (middleValue != widget.value) {
        widget.onChanged(widget.isHeight ? middleValue : middleValue / 10); //update selection
      }
    }
    return true;
  }
}

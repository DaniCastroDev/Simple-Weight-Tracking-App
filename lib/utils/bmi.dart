import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';

double calculateIBM(double weight, double height) {
  height = height / 100;
  return weight / (height * height);
}

double kgToLb(double weight) {
  return weight * 2.20462262185;
}

String getCategory(double ibm, context) {
  if (ibm < 16.0) {
    return DemoLocalizations.of(context).lowWeight;
  } else if (ibm < 17.0) {
    return DemoLocalizations.of(context).lowWeight;
  } else if (ibm < 18.5) {
    return DemoLocalizations.of(context).lowWeight;
  } else if (ibm < 24.9) {
    return DemoLocalizations.of(context).normalWeight;
  } else if (ibm < 29.9) {
    return DemoLocalizations.of(context).overWeight;
  } else if (ibm < 34.9) {
    return DemoLocalizations.of(context).obesityWeight;
  } else if (ibm < 39.9) {
    return DemoLocalizations.of(context).obesityWeight;
  } else {
    return DemoLocalizations.of(context).obesityWeight;
  }
}

List<double> fronteras = [15, 18.5, 25, 30, 40];

Color getColorByIBM(double ibm) {
  if (ibm < 16.0) {
    return Colors.blue;
  } else if (ibm < 17.0) {
    return Colors.blue;
  } else if (ibm < 18.5) {
    return Colors.blue;
  } else if (ibm < 24.9) {
    return AppThemes.CYAN;
  } else if (ibm < 29.9) {
    return Colors.yellow;
  } else if (ibm < 34.9) {
    return Colors.red;
  } else if (ibm < 39.9) {
    return Colors.red;
  } else {
    return Colors.red;
  }
}

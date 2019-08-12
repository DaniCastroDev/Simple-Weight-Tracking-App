double inchToCm(double inch) {
  return (inch * 2.54);
}

double inchToFeet(double inch) {
  return (inch / 12);
}

double feetToInches(double feet) {
  return (feet * 12);
}

double cmToInch(double cm) {
  return cm / 2.54;
}

double kgToLb(double weight) {
  return double.parse((weight * 2.20462262185).toStringAsFixed(1));
}

double lbToKg(double weight) {
  return double.parse((weight / 2.20462262185).toStringAsFixed(1));
}

String feetToCentimeter(String feet) {
  double dCentimeter = 0;
  if (feet.isNotEmpty) {
    if (feet.contains("'")) {
      String tempfeet = feet.substring(0, feet.indexOf("'"));
      if (tempfeet.isNotEmpty) {
        dCentimeter += ((double.parse(tempfeet)) * 30.48);
      }
    }
    if (feet.contains("\"")) {
      String tempinch = feet.substring(feet.indexOf("'") + 1, feet.indexOf("\""));
      if (tempinch.isNotEmpty) {
        dCentimeter += ((double.parse(tempinch)) * 2.54);
      }
    }
  }
  return dCentimeter.toString();
  //Format to decimal digit as per your requirement
}

String centimeterToFeet(String centemeter) {
  int feetPart = 0;
  int inchesPart = 0;
  if (centemeter.isNotEmpty) {
    double dCentimeter = double.parse(centemeter);
    feetPart = ((dCentimeter / 2.54) / 12).floor();
    inchesPart = ((dCentimeter / 2.54) - (feetPart * 12)).floor();
  }
  return "$feetPart' $inchesPart''";
}

String getUnitOfMeasure(bool isRetarded) {
  return isRetarded ? 'lb' : 'kg';
}

double getValueToDBWeightAsDouble(bool isRetarded, double weight) {
  return isRetarded ? weight : kgToLb(weight);
}

double getValueFromDBWeightAsDouble(bool isRetarded, double weight) {
  return isRetarded ? weight : lbToKg(weight);
}

String getCorrectWeight(bool isRetarded, double weight) {
  return isRetarded ? weight.toStringAsFixed(1) : lbToKg(weight).toStringAsFixed(1);
}

String getCorrectHeight(bool isRedarted, double cm) {
  return isRedarted ? centimeterToFeet(cm.toString()) : cm.toString();
}

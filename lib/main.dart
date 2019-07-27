import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/weights.dart';
import 'package:simple_weight_tracking_app/screens/add_weight_screen.dart';
import 'package:simple_weight_tracking_app/screens/history_screen.dart';
import 'package:simple_weight_tracking_app/screens/register_screen.dart';
import 'package:simple_weight_tracking_app/screens/profile_screen.dart';
import 'package:simple_weight_tracking_app/utils/bmi.dart';
import 'package:simple_weight_tracking_app/utils/fade_transition.dart';
import 'package:simple_weight_tracking_app/widgets/bmi_graphic.dart';
import 'package:simple_weight_tracking_app/widgets/weight_chart.dart';
import 'package:simple_weight_tracking_app/widgets/weight_register_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'appthemes.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        canvasColor: AppThemes.BLACK_BLUE,
      ),
      localizationsDelegates: [
        const CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
      ],
      home: RegisterScreen(),
    );
  }
}

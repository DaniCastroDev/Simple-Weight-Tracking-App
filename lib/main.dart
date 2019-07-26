import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/weights.dart';
import 'package:simple_weight_tracking_app/screens/add_weight_screen.dart';
import 'package:simple_weight_tracking_app/screens/history_screen.dart';
import 'package:simple_weight_tracking_app/screens/settings_screen.dart';
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 180.0;
  double currentWeight;
  MyDatabase db = MyDatabase();
  List<String> sharedValues = [];
  List<Weight> weights = [];
  double initialWeight = 100.0;
  double objectiveWeight = 50.0;
  bool isRetardUnits = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return StreamBuilder(
      stream: db.allWeightEntriesStream,
      builder: ((context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            backgroundColor: AppThemes.BLACK_BLUE,
            body: CircularProgressIndicator(),
          );
        }
        weights = snapshot.data;
        currentWeight = weights.last.weight;
        return Scaffold(
          backgroundColor: AppThemes.BLACK_BLUE,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            color: AppThemes.CYAN,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
              child: Text(
                DemoLocalizations.of(context).addWeight.toUpperCase(),
                style: TextStyle(letterSpacing: 3.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
              ),
            ),
            onPressed: () async {
              await Navigator.of(context).push(FadeTransitionRoute(widget: SelectWeightScreen()));
              setState(() {});
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Stack(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: AppThemes.GREY,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(FadeTransitionRoute(widget: SettingsScreen()));
                            }),
                        weights != null && weights.length > 1
                            ? WeightChart(weights, isRetardUnits)
                            : Container(
                                height: 140.0,
                                child: Center(
                                  child: Text(
                                    DemoLocalizations.of(context).notEnoughData,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppThemes.GREY,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20.0, right: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 25.0,
                        ),
                        _goalProgress(),
                        Container(
                          height: 25.0,
                        ),
                        _calculateBMI(),
                        Container(
                          height: 25.0,
                        ),
                        _historyCards(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  _calculateBMI() {
    double ibm = calculateIBM(currentWeight, height);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DemoLocalizations.of(context).ibmTitle,
          style: TextStyle(color: AppThemes.GREY, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 5.0,
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: AppThemes.GREY_GREENER,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${ibm.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '${getCategory(ibm, context).toUpperCase()}',
                          style: TextStyle(color: getColorByIBM(ibm), fontSize: 12.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 15.0,
                  ),
                  BMIGraphic(ibm: ibm),
                ],
              )),
        ),
      ],
    );
  }

  _historyCards() {
    List<WeightRegisterCard> cards = [];
    if (weights.length > 7) {
      for (int i = 6; i >= 0; i--) {
        cards.add(WeightRegisterCard(weight: weights[i], difference: i > 0 ? weights[i].weight - weights[i - 1].weight : null));
      }
    } else {
      for (int i = weights.length - 1; i >= 0; i--) {
        cards.add(WeightRegisterCard(weight: weights[i], difference: i > 0 ? weights[i].weight - weights[i - 1].weight : null));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Text(
                DemoLocalizations.of(context).history,
                style: TextStyle(color: AppThemes.GREY, fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(FadeTransitionRoute(widget: HistoryScreen(weights))),
              child: Text(
                DemoLocalizations.of(context).seeAll,
                style: TextStyle(color: AppThemes.CYAN, fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Container(
          height: 5.0,
        ),
        Hero(
          tag: 'listaHistorial',
          child: Column(
            children: cards,
          ),
        )
      ],
    );
  }

  String _getUnitOfMeasure() {
    return isRetardUnits ? 'lb' : 'kg';
  }

  String _getCorrectWeight(double weight) {
    return isRetardUnits ? kgToLb(weight).toStringAsFixed(1) : weight.toStringAsFixed(1);
  }

  _goalProgress() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _getCorrectWeight(initialWeight),
                    style: TextStyle(color: AppThemes.GREY, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      _getUnitOfMeasure(),
                      style: TextStyle(color: AppThemes.GREY, fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  _getCorrectWeight(currentWeight),
                  style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 9.0),
                  child: Text(
                    _getUnitOfMeasure(),
                    style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    _getCorrectWeight(objectiveWeight),
                    style: TextStyle(color: AppThemes.GREY, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      _getUnitOfMeasure(),
                      style: TextStyle(color: AppThemes.GREY, fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        LinearPercentIndicator(
          padding: EdgeInsets.all(0.0),
          width: MediaQuery.of(context).size.width - 40,
          lineHeight: 3.0,
          percent: (currentWeight - initialWeight) / (objectiveWeight - initialWeight) < 1
              ? (currentWeight - initialWeight) / (objectiveWeight - initialWeight) > 0 ? (currentWeight - initialWeight) / (objectiveWeight - initialWeight) : 0
              : 1,
          backgroundColor: AppThemes.GREY,
          progressColor: AppThemes.CYAN,
        ),
      ],
    );
  }

  @override
  void initState() {
    print('INIT');
    super.initState();
  }
}

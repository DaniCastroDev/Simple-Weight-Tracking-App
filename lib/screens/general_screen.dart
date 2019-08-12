import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/screens/add_weight_screen.dart';
import 'package:simple_weight_tracking_app/screens/history_screen.dart';
import 'package:simple_weight_tracking_app/utils/bmi.dart';
import 'package:simple_weight_tracking_app/utils/fade_transition.dart';
import 'package:simple_weight_tracking_app/utils/units.dart';
import 'package:simple_weight_tracking_app/widgets/bmi_graphic.dart';
import 'package:simple_weight_tracking_app/widgets/weight_chart.dart';
import 'package:simple_weight_tracking_app/widgets/weight_register_card.dart';

class GeneralScreen extends StatelessWidget {
  final InfoUser infoUser;
  final List<Weight> weights;
  final FirebaseUser user;

  GeneralScreen({this.infoUser, this.weights, this.user});

  @override
  Widget build(BuildContext context) {
    Weight currentWeight = weights.last;
    _calculateBMI() {
      double ibm = calculateIBM(lbToKg(currentWeight.weight), infoUser.height);
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
          cards.add(WeightRegisterCard(isRetarded: infoUser.retardedUnits, weight: weights[i], difference: i > 0 ? weights[i].weight - weights[i - 1].weight : null));
        }
      } else {
        for (int i = weights.length - 1; i >= 0; i--) {
          cards.add(WeightRegisterCard(isRetarded: infoUser.retardedUnits, weight: weights[i], difference: i > 0 ? weights[i].weight - weights[i - 1].weight : null));
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
                onTap: () => Navigator.of(context).push(FadeTransitionRoute(widget: HistoryScreen(weights, infoUser))),
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

    _goalProgress() {
      return Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 40) / 3),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              getCorrectWeight(infoUser.retardedUnits, infoUser.initialWeight),
                              style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 30.0 : 20.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                getUnitOfMeasure(infoUser.retardedUnits),
                                style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 14.0 : 10.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.yMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateInitialWeight),
                          style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 17.0 : 14.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 40) / 3),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          getCorrectWeight(infoUser.retardedUnits, currentWeight.weight),
                          style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height > 600 ? 45.0 : 30.0, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9.0),
                          child: Text(
                            getUnitOfMeasure(infoUser.retardedUnits),
                            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height > 600 ? 20.0 : 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 40) / 3),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              getCorrectWeight(infoUser.retardedUnits, infoUser.objectiveWeight),
                              style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 30.0 : 20.0, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                getUnitOfMeasure(infoUser.retardedUnits),
                                style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 14.0 : 10.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat.yMd(DemoLocalizations.of(context).locale.languageCode).format(infoUser.dateObjectiveWeight),
                          style: TextStyle(color: AppThemes.GREY, fontSize: MediaQuery.of(context).size.height > 600 ? 17.0 : 14.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.all(0.0),
            width: MediaQuery.of(context).size.width - 40,
            lineHeight: 3.0,
            percent: (currentWeight.weight - infoUser.initialWeight) / (infoUser.objectiveWeight - infoUser.initialWeight) < 1
                ? (currentWeight.weight - infoUser.initialWeight) / (infoUser.objectiveWeight - infoUser.initialWeight) > 0
                    ? (currentWeight.weight - infoUser.initialWeight) / (infoUser.objectiveWeight - infoUser.initialWeight)
                    : 0
                : 1,
            backgroundColor: AppThemes.GREY,
            progressColor: AppThemes.CYAN,
          ),
        ],
      );
    }

    return Builder(
      builder: (builderContext) {
        List<Weight> predictedWeights = [];

        if (infoUser.activeObjectives) {
          Duration days = infoUser.dateObjectiveWeight.difference(infoUser.dateInitialWeight.subtract(Duration(days: 1)));
          double weightDifference = infoUser.initialWeight - infoUser.objectiveWeight;
          double weightPerDay = weightDifference / days.inDays;
          for (int i = 0; i < days.inDays; i++) {
            predictedWeights.add(Weight(infoUser.dateInitialWeight.add(Duration(days: i)), infoUser.initialWeight - (weightPerDay * i)));
          }
        }
        return SafeArea(
          child: Scaffold(
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    color: AppThemes.CYAN,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      child: Text(
                        DemoLocalizations.of(context).addWeight.toUpperCase(),
                        style: TextStyle(letterSpacing: 3.0, color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(FadeTransitionRoute(
                          widget: SelectWeightScreen(
                        user: user,
                        infoUser: infoUser,
                      )));
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Stack(
                      alignment: Alignment(-1, -0.95),
                      children: <Widget>[
                        InkWell(
                          child: Icon(
                            Icons.menu,
                            size: 35.0,
                            color: AppThemes.GREY,
                          ),
                          onTap: () {
                            Scaffold.of(builderContext).openDrawer();
                          },
                        ),
                        weights != null && weights.length > 0
                            ? WeightChart(
                                objectiveWeights: predictedWeights,
                                weights: weights,
                                isRetardUnits: infoUser.retardedUnits,
                              )
                            : Container(
                                height: 200.0,
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
                        infoUser.activeObjectives
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 25.0,
                                  ),
                                  _goalProgress(),
                                ],
                              )
                            : Container(),
                        Container(
                          height: 25.0,
                        ),
                        _calculateBMI(),
                        Container(
                          height: 25.0,
                        ),
                        _historyCards(),
                        Container(
                          height: 75.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/widgets/weight_register_card.dart';

class HistoryScreen extends StatelessWidget {
  final List<Weight> weights;

  HistoryScreen(this.weights);

  @override
  Widget build(BuildContext context) {
    List<Weight> reversedWeights = weights.reversed.toList();
    return Scaffold(
      backgroundColor: AppThemes.BLACK_BLUE,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'historial',
            child: Material(
              color: Colors.transparent,
              child: Text(
                DemoLocalizations.of(context).history,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Hero(
          tag: 'listaHistorial',
          child: ListView.builder(
              itemCount: weights.length,
              itemBuilder: (context, index) {
                return WeightRegisterCard(
                  weight: reversedWeights[index],
                );
              }),
        ),
      ),
    );
  }
}

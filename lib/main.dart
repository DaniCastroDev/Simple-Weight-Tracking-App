import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weight_tracking_app/widgets/alert.dart';

import 'appthemes.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String LIST_WEIGHTS = "weights";
  TextEditingController _weightController;
  SharedPreferences prefs;
  List<String> weights;

  @override
  Widget build(BuildContext context) {
    return prefs == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            backgroundColor: AppThemes.BLUE,
            body: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            backgroundColor: AppThemes.BLUE,
            body: ListView.builder(
              itemCount: weights.length,
              itemBuilder: (context, index) {
                return Text(weights[index]);
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppThemes.YELLOW,
              child: Icon(Icons.add),
              onPressed: () {
                _onAlertWithCustomContentPressed(context);
              },
            ),
          );
  }

  _onAlertWithCustomContentPressed(context) {
    CustomAlert(
        context: context,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: Container(
                width: 100.0,
                child: TextField(
                  controller: _weightController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)), contentPadding: EdgeInsets.all(10.0)),
                ),
              ),
            ),
            Text(
              'KG',
              style: TextStyle(color: Colors.black, fontSize: 40.0),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => _incrementCounter(context),
            child: Text(
              "Añadir peso",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _incrementCounter(context) {
    setState(() {
      weights.add(_weightController.text);
      prefs.setStringList(LIST_WEIGHTS, weights);
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    _weightController = TextEditingController();
    SharedPreferences.getInstance().then((_instance) {
      setState(() {
        prefs = _instance;
        weights = prefs.getStringList(LIST_WEIGHTS) ?? [];
      });
    });
    super.initState();
  }
}

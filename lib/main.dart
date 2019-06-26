import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: AppThemes.BLUE,
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemes.YELLOW,
        child: Icon(Icons.add),
        onPressed: () {
          _onAlertWithCustomContentPressed(context);
        },
      ),
    );
  }

// Alert custom content
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
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Añadir peso",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}

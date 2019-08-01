import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)), color: Colors.white.withOpacity(0.95)),
          padding: EdgeInsets.all(80.0),
          child: CircularProgressIndicator(
            backgroundColor: AppThemes.CYAN,
            valueColor: new AlwaysStoppedAnimation<Color>(AppThemes.BLACK_BLUE),
          )),
    );
  }
}

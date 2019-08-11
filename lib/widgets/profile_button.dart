import 'package:flutter/material.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';

class ProfilePhoto extends StatefulWidget {
  final String imageUrl;
  final double size;

  ProfilePhoto({this.imageUrl, this.size = 50.0});

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppThemes.CYAN, shape: BoxShape.circle),
      padding: EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(color: AppThemes.BLACK_BLUE, shape: BoxShape.circle),
        padding: EdgeInsets.all(5.0),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: widget.imageUrl != null ? NetworkImage(widget.imageUrl) : AssetImage('assets/images/empty-image.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}

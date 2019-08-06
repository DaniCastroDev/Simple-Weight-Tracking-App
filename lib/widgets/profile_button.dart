import 'package:flutter/material.dart';

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
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: widget.imageUrl != null ? NetworkImage(widget.imageUrl) : AssetImage('assets/images/empty-image.jpg'),
        ),
      ),
    );
  }
}

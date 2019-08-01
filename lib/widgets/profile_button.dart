import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  final String imageUrl;
  final double size;

  ProfileButton({this.imageUrl, this.size = 50.0});

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
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

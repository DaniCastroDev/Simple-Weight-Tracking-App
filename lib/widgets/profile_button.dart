import 'package:flutter/material.dart';

class ProfileButton extends StatefulWidget {
  final String imageUrl;

  ProfileButton({this.imageUrl});

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: widget.imageUrl != null ? NetworkImage(widget.imageUrl) : AssetImage('assets/iamges/plain-logo.png'),
        ),
      ),
    );
  }
}

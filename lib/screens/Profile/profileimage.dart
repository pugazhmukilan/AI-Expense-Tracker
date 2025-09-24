import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 50,
        backgroundImage: AssetImage("assets/icons/profile.png"),
      ),
    );
  }
}
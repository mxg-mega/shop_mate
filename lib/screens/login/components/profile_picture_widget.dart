import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? profilePictureUrl;

  const ProfilePictureWidget({Key? key, this.profilePictureUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: profilePictureUrl != null
          ? NetworkImage(profilePictureUrl!)
          : AssetImage('assets/images/default_profile_picture.png') as ImageProvider,
    );
  }
}

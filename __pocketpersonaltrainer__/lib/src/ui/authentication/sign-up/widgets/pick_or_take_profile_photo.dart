// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PickOrTakeProfilePhoto extends StatefulWidget {
  PickOrTakeProfilePhoto({
    Key? key,
    required this.profilePhoto,
  }) : super(key: key);

  String? profilePhoto;

  @override
  _PickOrTakeProfilePhotoState createState() => _PickOrTakeProfilePhotoState();
}

class _PickOrTakeProfilePhotoState extends State<PickOrTakeProfilePhoto> {
  ImageProvider buildSelectedPhoto() {
    if (widget.profilePhoto != '') {
      return NetworkImage(widget.profilePhoto!);
    } else {
      return const AssetImage("assets/images/person.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 9),
        child: CircleAvatar(
          backgroundImage: buildSelectedPhoto(),
        ),
      ),
    );
  }
}

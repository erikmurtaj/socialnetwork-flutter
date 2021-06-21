import 'package:flutter/material.dart';

import '../../constant.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final Function onPress;

  ProfileButton({@required this.text,@required this.onPress});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      color: kBlueColor,
      minWidth: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: kWhiteColor,
        ),
      ),
    );
  }
}

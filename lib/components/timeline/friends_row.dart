import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/model/user.dart';

import '../../constants.dart';

class FriendsRow extends StatelessWidget{
  List<User> users;

  FriendsRow(this.users);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: kWhiteColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Make new friends',
                  style: TextStyle(
                    fontSize: 20,
                    color: kBlueColor,
                  ),
                ),
              ],
            ),
          ),

          /// Friends row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: paddingFriendsList(),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  paddingFriendsList(){
    List<Widget> paddings = [];
    paddings.add(
      SizedBox(
        width: 28,),
    );
    this.users.forEach((user) {
      paddings.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              radius: 35,
              backgroundImage:
              CachedNetworkImageProvider(user.photoUrl),
            ),
          )
      );
      paddings.add(Text(user.full_name));
    });
    paddings.add(
      SizedBox(
        width: 35,),
    );
    return paddings;
  }

}
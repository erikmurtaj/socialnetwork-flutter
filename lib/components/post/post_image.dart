import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:socialnetwork_flutter/model/post.dart';
import 'package:socialnetwork_flutter/model/user.dart';
import '../../home_page.dart';

class PostImage<Post> extends StatelessWidget {
  final post;
  User user;

  PostImage({this.post});

  void getUser(user_id) async {
    DocumentSnapshot doc = await usersRef.doc(user_id).get();
    user = User.fromDocument(doc);
  }

  @override
  Widget build(BuildContext context) {
    getUser(post.ownerId);
    return GestureDetector(
        /*onTap: (){

        },
        onDoubleTap: (){

        },
        child: Container(
          color: Colors.white,
          height: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Container(
                       height: 40,
                       width: 40,
                       decoration: BoxDecoration(
                         color: Colors.grey[100],
                         shape: BoxShape.circle,
                         image: DecorationImage(image: AssetImage(
                           Us,
                         ),fit: BoxFit.fill)
                       ),
                     ),
                   ),
                    Text(username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                    Expanded(child: SizedBox()),
                    IconButton(icon: Icon(Icons.more_vert, color: Colors.grey[500],), onPressed: (){
                      
                    })
                  ],
                ),
              ),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  image: DecorationImage(image: AssetImage(post_data),
                      fit: BoxFit.fill)
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8,),
                   Icon(LineAwesomeIcons.heart_o, size: 30,),
                    SizedBox(width: 8,),
                    Icon(LineAwesomeIcons.comment, size: 30,),
                    SizedBox(width: 8,),
                    Icon(LineAwesomeIcons.paper_plane_o, size: 30,),
                    Expanded(child: SizedBox()),
                    Icon(LineAwesomeIcons.bookmark_o, size: 35,),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left :8.0),
                child: Text(likes,style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black,fontSize: 15),),
              ),
              Container(
                width: double.infinity,
                height: 30,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left :8.0,right: 5),
                      child: Text(username,style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),),
                    ),
                    Expanded(child: Text("View all ${comments_no} Comments.",style: TextStyle(color: Colors.grey[500],),)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left :8.0),
                child: Text(comments,style: TextStyle(color: Colors.grey[500],),),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right :8.0),
                    child: Container(
                     height: 40,
                     width: 40,
                     decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage(user_pic),fit: BoxFit.fill)
                       ),
                     ),
                  ),
                   Expanded(
                     child: TextField(
                       decoration: InputDecoration(
                         hintText: "Add a comment",
                         border: InputBorder.none,
                         hintStyle: TextStyle(fontSize: 12,)
                       ),
                     ),
                   ),
                   Icon(FontAwesome.heart, color: Colors.red, size: 13,),
                    SizedBox(width: 5,),
                    Icon(Icons.insert_emoticon, color: Colors.yellowAccent, size: 13,),
                    SizedBox(width: 5,),
                    Icon(FontAwesome.plus_circle, color: Colors.grey[200], size: 13,),

                  ],
                ),
              )
            ],
          ),
        ),*/
      );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/home_page.dart';
import 'package:socialnetwork_flutter/model/comment.dart';
import 'package:socialnetwork_flutter/model/user.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentBuild extends StatelessWidget{
  final Comment comment;

  CommentBuild({this.comment});

  @override
  Widget build(BuildContext context) {

    //User user = User.fromDocument(usersRef.doc(comment.userId).get());
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment.comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider("https://static.vecteezy.com/ti/vettori-gratis/p2/439863-icona-utenti-gratuito-vettoriale.jpg"),
          ),
          subtitle: Text(timeago.format(comment.timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }

}
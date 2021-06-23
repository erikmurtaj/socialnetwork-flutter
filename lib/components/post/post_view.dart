import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../authentication/authentication_service.dart';
import '../../pages/comments.dart';
import '../../pages/home_page.dart';
import '../../model/post.dart';
import '../../model/user.dart';

class PostView extends StatefulWidget {
  final Post post;

  PostView({this.post});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLiked;
  bool showHeart = false;

  @override
  Widget build(BuildContext context) {
    isLiked = (widget.post.likes[current_uid] == true);
    return Container(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
          buildPostImage(),
          buildPostFooter()
        ],
    ));
  }

  buildPostHeader() {
    return Container(
        child: FutureBuilder(
          future: usersRef.doc(widget.post.ownerId).get(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            User user = User.fromDocument(snapshot.data);
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                //TODO: show profile
                onTap: () => print("show Profile"),
                child: Text(
                  user.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(widget.post.location),
              trailing: IconButton(
                //TODO: delete post
                onPressed: () => print("deleting post"),
                icon: Icon(Icons.more_vert),
              ),
            );
          }
      )
    );
  }

  buildPostImage() {
    return Container(
      height: 500,
        child: GestureDetector(
          onDoubleTap: handleLikePost,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.network(widget.post.mediaUrl),
              showHeart ? Icon(Icons.favorite, size: 80.0, color: Colors.red,) :
                  Text("")
            ],
          ),
        )
    );
  }

  buildPostFooter() {
    int likesCount = widget.post.getLikeCount();
    String username = widget.post.username;
    String description = widget.post.description;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: handleLikePost,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: widget.post.id,
                ownerId: widget.post.ownerId,
                mediaUrl: widget.post.mediaUrl
              ),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likesCount likes",
                style: TextStyle(color: Colors.black)
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                  "$description",
                  style: TextStyle(color: Colors.black)
              ),
            ),
          ],
        )
      ],
    );
  }

  handleLikePost(){
    bool _isLiked = widget.post.likes[current_uid] == true;

    if(_isLiked){
      postsRef
        .doc(widget.post.ownerId)
        .collection("userPosts")
        .doc(widget.post.id)
        .update({'likes.$current_uid': false});
      removeLikeToActivityFeed();
      setState(() {
        widget.post.likesCount -= 1;
        isLiked = false;
        widget.post.likes[current_uid] = false;
      });
    } else{
      postsRef
          .doc(widget.post.ownerId)
          .collection("userPosts")
          .doc(widget.post.id)
          .update({'likes.$current_uid': true});
      addLikeToActivityFeed();
      setState(() {
          widget.post.likesCount += 1;
          isLiked = true;
          widget.post.likes[current_uid] = true;
          showHeart = true;
      });
      Timer(Duration(milliseconds: 500), (){
          setState(() {
            showHeart = false;
          });
        }
      );
    }
  }

  addLikeToActivityFeed(){
    //TODO: check if is an own like
    feedRef
        .doc(widget.post.ownerId)
        .collection("feedItems")
        .doc(widget.post.id)
        .set({
          "type": "like",
          "username": currentUser.username,
          "userId": currentUser.id,
          "postId": widget.post.id,
          "commentData": "",
          "mediaUrl": widget.post.mediaUrl,
          "timestamp": timestamp
        });
  }

  removeLikeToActivityFeed(){
    feedRef
        .doc(widget.post.ownerId)
        .collection("feedItems")
        .doc(widget.post.id)
        .get().then((doc){
          if(doc.exists){
            doc.reference.delete();
          }
        });
  }

  showComments(BuildContext context, {String postId, String ownerId, String mediaUrl}){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        Comments(
          postId: postId,
          postOwnerId: ownerId,
          postMediaUrl: mediaUrl
    )));
  }

}
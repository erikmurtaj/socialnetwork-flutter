import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/components/post/comment_build.dart';
import 'package:socialnetwork_flutter/model/comment.dart';

import 'home_page.dart';

class Comments extends StatefulWidget{
  final String postId;
  final String postOwnerId;
  final String postMediaUrl;

  Comments({this.postId, this.postOwnerId, this.postMediaUrl});


  @override
  _CommentsState createState() => _CommentsState();

}

class _CommentsState extends State<Comments>{
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments"),),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment..."),
            ),
            trailing: OutlinedButton(
              onPressed: addComment,
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
              ),
              child: Text("Post"),
            )
          ),
        ],
      ),
    );
  }

  buildComments() {
    return StreamBuilder(
      stream: commentsRef.doc(widget.postId).collection("comments")
                .orderBy("timestamp", descending: false).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        List<Comment> comments = [];
        snapshot.data.docs.forEach((doc){
          comments.add(Comment.fromDocument(doc));
        });
        print("comments.length: ");
        print(comments.length);
        List<Widget> comments_build = [];
        for(int i=0; i<comments.length; i++){
          comments_build.add(CommentBuild(comment: comments[i],));
        }
        return ListView(children: comments_build,);
      },
    );
  }

  addComment(){
    commentsRef
        .doc(widget.postId)
        .collection("comments")
        .add({
          "username": currentUser.username,
          "comment": commentController.text,
          "timestamp": timestamp,
          "userId": current_uid,
        });

    //TODO: check if the same user
    feedRef
        .doc(widget.postOwnerId)
        .collection("feedItems")
        .add({
          "type": "comment",
          "username": currentUser.username,
          "userId": widget.postOwnerId,
          "postId": widget.postId,
          "commentData": commentController.text,
          "mediaUrl": widget.postMediaUrl,
          "timestamp": timestamp
        });
    commentController.clear();
  }

}
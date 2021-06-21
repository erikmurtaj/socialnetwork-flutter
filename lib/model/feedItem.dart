import 'package:cloud_firestore/cloud_firestore.dart';

class FeedItem{
  final String username;
  final String userId;
  final String type;  // 'like', 'follow', 'comment'
  final String postId;
  final String mediaUrl;
  final String commentData;
  final Timestamp timestamp;

  FeedItem({this.username, this.userId, this.type, this.postId, this.mediaUrl, this.commentData, this.timestamp});

  factory FeedItem.fromDocument(DocumentSnapshot doc){
    return FeedItem(
        username: doc['username'],
        userId: doc['userId'],
        type: doc['type'],
        postId: doc["postId"],
        mediaUrl: doc['mediaUrl'],
        commentData: doc['commentData'],
        timestamp: doc['timestamp'],
    );
  }


}
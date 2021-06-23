import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork_flutter/model/post.dart';
import 'package:socialnetwork_flutter/components/post/post_view.dart';


class SinglePostView extends StatefulWidget {
  final Post post;

  SinglePostView({this.post});

  @override
  _SinglePostViewState createState() => _SinglePostViewState();
}

class _SinglePostViewState extends State<SinglePostView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PostView(post: widget.post,)
    );
  }

}
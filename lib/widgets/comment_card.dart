import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:instagram_clone/models/userModel.dart' as model;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class commentCard extends StatefulWidget {
  final snap;
  const commentCard({
    super.key,
    required this.snap,
  });

  @override
  State<commentCard> createState() => _commentCardState();
}

class _commentCardState extends State<commentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profilepic']),
          radius: 19,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: widget.snap['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${widget.snap['text']}'),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datepublish'].toDate()),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.favorite),
        )
      ]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instagram_clone/models/userModel.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore.dart';
import 'package:instagram_clone/screen/commentScreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_ani.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/userModel.dart' as model;

class post_card extends StatefulWidget {
  final snap;
  const post_card({super.key, required this.snap});

  @override
  State<post_card> createState() => _post_cardState();
}

class _post_cardState extends State<post_card> {
  bool islikeani = false;
  var clength = 0;
  void iniState() {
    super.initState();
    getComment();
  }

  void getComment() async {
    try {
      QuerySnapshot snap = (await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get());
      clength = snap.docs.length;
      //print(clength);
    } catch (e) {
      showSnakBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser!;
    return user==null? Center(child: CircularProgressIndicator(),):
    
     Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(widget.snap['profilImage']),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snap['username'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    )
                  ]),
            )),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: ListView(
                              padding: EdgeInsets.symmetric(vertical: 36),
                              shrinkWrap: true,
                              children: [
                                "Delete",
                              ]
                                  .map((e) => InkWell(
                                      onTap: () async {
                                        Firestoremethod()
                                            .deletepost(widget.snap['postid']);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      )))
                                  .toList(),
                            ),
                          ));
                },
                icon: Icon(Icons.more_vert))
          ]),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await Firestoremethod().likepost(
                widget.snap['postid'], user!.uid, widget.snap['likes']);
            setState(() {
              islikeani = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.39,
              width: double.infinity,
              child: Image.network(
                widget.snap['posturl'],
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: islikeani ? 1 : 0,
              child: likeAni(
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 150,
                ),
                isani: islikeani,
                durationtime: Duration(milliseconds: 400),
                onEnd: () {
                  setState(() {
                    islikeani = false;
                  });
                },
              ),
            )
          ]),
        ),
        Row(
          children: [
            likeAni(
                isani: widget.snap['likes'].contains(user!.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await Firestoremethod().likepost(widget.snap['postid'],
                          user.uid, widget.snap['likes']);
                      setState(() {
                        islikeani = true;
                      });
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(Icons.favorite_border))),
            IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                          snap: widget.snap,
                        ))),
                icon: Icon(
                  Icons.comment_outlined,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                )),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark,
                  )),
            ))
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text('${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 8),
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                      TextSpan(
                          text: widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                      )
                    ])),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'view all comments',
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datepublish'].toDate()),
                  style: TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
              Divider()
            ],
          ),
        )
      ]),
    );
  }
}

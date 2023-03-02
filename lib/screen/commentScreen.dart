import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/userModel.dart' as model;
import '../provider/user_provider.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postid'])
            .collection('comments')
            .orderBy('datepublish', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
         return   Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (contex, index) =>
                  commentCard(snap: snapshot.data!.docs[index].data()));
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user!.picurl),
            radius: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                    hintText: "Comment as ${user.username}",
                    border: InputBorder.none),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Firestoremethod().postcomment(
                widget.snap['postid'],
                user.uid,
                commentController.text,
                user.picurl,
                user.username,
              );
              setState(() {
                commentController.text = "";
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text(
                'Post',
                style: TextStyle(color: Colors.blueAccent, fontSize: 17),
              ),
            ),
          )
        ]),
      )),
    );
  }
}

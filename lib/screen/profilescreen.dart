import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/resources/firestore.dart';
import 'package:instagram_clone/screen/loginscreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../widgets/follobutton.dart';

class profilescreen extends StatefulWidget {
  final String uid;
  const profilescreen({super.key, required this.uid});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  var userdata = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isfollow = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postlen = postsnap.docs.length;
      userdata = usersnap.data()!;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isfollow = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnakBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
            ),
            body: ListView(children: [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userdata['picurl']),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildcolumn(postlen, "posts"),
                                  buildcolumn(followers, "followers"),
                                  buildcolumn(following, "following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? follobutton(
                                          text: "Sign out",
                                          backgroundcolor:
                                              mobileBackgroundColor,
                                          textcolor: primaryColor,
                                          bordercolor: Colors.grey,
                                          function: () async {
                                            await AuthMethod().signout();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            loginScreenState()));
                                          },
                                        )
                                      : isfollow
                                          ? follobutton(
                                              text: "Unfollow",
                                              backgroundcolor: Colors.white,
                                              textcolor: Colors.black,
                                              bordercolor: Colors.grey,
                                              function: () async {
                                                await Firestoremethod()
                                                    .followuser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userdata['uid'],
                                                );
                                                setState(() {
                                                  isfollow = false;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : follobutton(
                                              text: "Follow",
                                              backgroundcolor: Colors.black,
                                              textcolor: Colors.white,
                                              bordercolor: Colors.blue,
                                              function: () async {
                                                await Firestoremethod()
                                                    .followuser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userdata['uid']);
                                                setState(() {
                                                  isfollow = true;
                                                  followers++;
                                                });
                                              },
                                            )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        userdata['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 11),
                      child: Text(
                        userdata['bio'],
                        style: TextStyle(),
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, Snapshot) {
                          if (Snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  (Snapshot.data! as dynamic).docs.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 1.7,
                                      childAspectRatio: 1),
                              itemBuilder: (context, index) {
                                DocumentSnapshot snap =
                                    (Snapshot.data! as dynamic).docs[index];
                                return Container(
                                  child: Image(
                                    image: NetworkImage((snap['posturl'])),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              });
                        })
                  ],
                ),
              )
            ]),
          );
  }

  Column buildcolumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        )
      ],
    );
  }
}

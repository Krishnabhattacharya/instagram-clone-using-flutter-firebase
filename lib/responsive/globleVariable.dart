import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_postScreen.dart';
import 'package:instagram_clone/screen/feedScreen.dart';
import 'package:instagram_clone/screen/profilescreen.dart';
import 'package:instagram_clone/screen/searchScreen.dart';

const webScreen = 600;
List<Widget> homeScreenItems = [
  feedScreen(),
  searchScreen(),
  AddPostScreen(),
  Text('feed3'),
  // ignore: unnecessary_const
    profilescreen(uid:  FirebaseAuth.instance.currentUser!.uid,)
];

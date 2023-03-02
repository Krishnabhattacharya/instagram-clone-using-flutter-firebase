import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_postScreen.dart';
import 'package:instagram_clone/screen/feedScreen.dart';
import 'package:instagram_clone/screen/searchScreen.dart';

const webScreen = 600;
const  homeScreenItems = [
  feedScreen(),
  searchScreen(),
  AddPostScreen(),
  Text('feed3'),
  Text('feed4'),
];

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Post {
  final String description;
  final String uid;
  final String postid;
   final String posturl;
  final String username;
  final  datepublish;
  final String profilImage;
  final List likes;

  const Post(
      {required this.description,
      required this.uid,
      required this.postid,
      required this.posturl,
      required this.username,
      required this.datepublish,
      required this.profilImage,
      required this.likes
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot["description"],
      uid: snapshot["uid"],
      postid: snapshot["postid"],
      posturl: snapshot["posturl"],
      username: snapshot["username"],
      datepublish: snapshot["datepublish"],
      profilImage: snapshot["profilImage"],
      likes: snapshot["likes"],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postid": postid,
        "posturl": posturl,
        "username": username,
        "datepublish": datepublish,
        "profilImage": profilImage,
        "likes":likes,
      };
}
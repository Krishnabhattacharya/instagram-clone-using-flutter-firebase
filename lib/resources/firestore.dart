import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storageMethod.dart';
import 'package:uuid/uuid.dart';

class Firestoremethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> upload(String description, Uint8List file, String uid,
      String username, String profilImage) async {
    String res = "Some Error";
    try {
      String picurl = await storage().UploadImage("posts", file, true);
      String postId = Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          postid: postId,
          posturl: picurl,
          username: username,
          datepublish: DateTime.now(),
          profilImage: profilImage,
          likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likepost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postcomment(String postid, String uid, String text,
      String profilpic, String name) async {
    try {
      if (text.isNotEmpty) {
        String commentid = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .set({
          'profilepic': profilpic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentid': commentid,
          'datepublish': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletepost(String postid) async {
    try {
    await  _firestore.collection('posts').doc(postid).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}

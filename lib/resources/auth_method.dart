import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/userModel.dart' as model;
import 'package:instagram_clone/resources/storageMethod.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserdetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpuser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        String picurl = await storage().UploadImage('profilepic', file, false);

        model.User User = model.User(
            email: email,
            uid: cred.user!.uid,
            picurl: picurl,
            username: username,
            bio: bio,
            followers: [],
            following: []);

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(User.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "Email is badly formated";
      }
      // else if
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginuser({
    required String email,
    required String password,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Fill all the fields";
      }
    } catch (err) {
      res = err.toString();
      print(err);
    }
    return res;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}

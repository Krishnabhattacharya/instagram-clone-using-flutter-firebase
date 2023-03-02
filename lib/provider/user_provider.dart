import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/userModel.dart' as model;
import '../resources/auth_method.dart';

// class userProvider with ChangeNotifier {
//   User? _user;
//   User get getUser => _user!;
//   Future<void>referseuser()async{

//   }
// }
class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethod _authMethods = AuthMethod();

  model.User? get getUser => _user;

  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserdetails();
    _user = user;
    notifyListeners();
  }
}

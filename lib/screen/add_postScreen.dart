import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/userModel.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController _descriptionController = TextEditingController();
  Uint8List? _file;
  bool isloading = false;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      isloading = true;
    });
    try {
      String res = await Firestoremethod().upload(
          _descriptionController.text, _file!, uid, username, profileImage);
      if (res == "success") {
        setState(() {
          isloading = false;
          Clearimage();
        });
        showSnakBar('posted', context);
      } else {
        setState(() {
          isloading = false;
        });
        showSnakBar(res, context);
      }
    } catch (err) {
      showSnakBar(err.toString(), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void Clearimage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return (user == null)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _file == null
            ? Center(
                child: Container(
                child: IconButton(
                    onPressed: () {
                      _selectImage(context);
                    },
                    icon: Icon(Icons.upload)),
              ))
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: Clearimage,
                  ),
                  title: Text('Post To'),
                  actions: [
                    TextButton(
                        onPressed: () =>
                            postImage(user.uid, user.username, user.picurl),
                        child: Text(
                          'Post',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))
                  ],
                ),
                body: Column(
                  children: [
                    isloading
                        ? LinearProgressIndicator()
                        : Padding(padding: EdgeInsets.only(top: 0)),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              backgroundImage: NetworkImage(
                            user.picurl,
                          )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                hintText: "Write a caption...",
                                border: InputBorder.none,
                              ),
                              maxLines: 10,
                            ),
                          ),
                          SizedBox(
                            height: 45,
                            width: 45,
                            child: AspectRatio(
                                aspectRatio: 47 / 451,
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(_file!))))),
                          ),
                        ]),
                    Divider(),
                  ],
                ));
  }
}

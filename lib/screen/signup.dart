import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/screen/loginscreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textfield.dart';

import '../responsive/mobilescreen.dart';
import '../responsive/responsivScreen.dart';
import '../responsive/webscrren.dart';

class signupScreen extends StatefulWidget {
  const signupScreen({super.key});

  @override
  State<signupScreen> createState() => _signupScreen();
}

class _signupScreen extends State<signupScreen> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  Uint8List? _image;
  bool isloading = false;

  void dispose() {
    super.dispose();
    t1.dispose();
    t2.dispose();
    t3.dispose();
    t4.dispose();
  }

  void selectImage() async {
    Uint8List i = await pickImage(ImageSource.gallery);
    setState(() {
      _image = i;
    });
  }

  void navigateTologin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => loginScreenState()));
  }

  void signupUser() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethod().signUpuser(
        email: t2.text,
        password: t3.text,
        username: t1.text,
        bio: t4.text,
        file: _image!);

    if (res != 'success') {
      setState(() {
        isloading = false;
      });
      showSnakBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: mobilescreen(),
                webScreenLayout: webscreen(),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  SvgPicture.asset(
                    "assets/Instagram-Wordmark-White-Logo.wine.svg",
                    color: primaryColor,
                    height: 60,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  "https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg"),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: selectImage,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldinput(
                      textEditingController: t1,
                      hintText: "Enter Username",
                      textInputType: TextInputType.text),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldinput(
                      textEditingController: t2,
                      hintText: "Enter Email",
                      textInputType: TextInputType.emailAddress),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldinput(
                    textEditingController: t3,
                    hintText: "Enter password",
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldinput(
                    textEditingController: t4,
                    hintText: "Enter your bio",
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: signupUser,
                    // print(res);

                    child: Container(
                      child: isloading
                          ? Center(
                              child: SizedBox(
                                height: 5,
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Text("Sign up"),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: blueColor),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Text("Dont have an account?"),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: navigateTologin,
                        child: Container(
                          child: Text(
                            "Log in",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ));
  }
}

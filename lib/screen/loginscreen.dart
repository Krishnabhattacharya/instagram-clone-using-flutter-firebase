import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/responsive/globleVariable.dart';
import 'package:instagram_clone/screen/signup.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/textfield.dart';
import '../responsive/mobilescreen.dart';
import '../responsive/responsivScreen.dart';
import '../responsive/webscrren.dart';

class loginScreenState extends StatefulWidget {
  const loginScreenState({super.key});

  @override
  State<loginScreenState> createState() => _loginScreenStateState();
}

class _loginScreenStateState extends State<loginScreenState> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  bool isloading = false;

  @override
  void dispose() {
    super.dispose();
    t1.dispose();
    t2.dispose();
  }

  void navigateTosignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => signupScreen()));
  }

  void loginUser() async {
    setState(() {
      isloading = true;
    });
    String res =
        await AuthMethod().loginuser(email: t1.text, password: t2.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
                mobileScreenLayout: mobilescreen(),
                webScreenLayout: WebScreenLayout(),
              )));
      setState(() {
        isloading = false;
      });
    } else {
      setState(() {
        isloading = false;
      });
      showSnakBar(res, context);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: MediaQuery.of(context).size.width > webScreen
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          SvgPicture.asset(
            "assets/Instagram-Wordmark-White-Logo.wine.svg",
            color: primaryColor,
            height: 64,
          ),
          SizedBox(
            height: 65,
          ),
          TextFieldinput(
              textEditingController: t1,
              hintText: "Enter Email",
              textInputType: TextInputType.emailAddress),
          SizedBox(
            height: 30,
          ),
          TextFieldinput(
            textEditingController: t2,
            hintText: "Enter Password",
            textInputType: TextInputType.text,
            isPass: true,
          ),
          SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: loginUser,
            child: Container(
              child: isloading
                  ? Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : Text("Login"),
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
            height: 14,
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
                onTap: navigateTosignup,
                child: Container(
                  child: Text(
                    "Sign up",
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

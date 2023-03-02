import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/provider/user_provider.dart';

import 'package:instagram_clone/responsive/globleVariable.dart';
import 'package:provider/provider.dart';

// class responsiveScreen extends StatefulWidget {
//   final Widget webScreenLayout;
//   final Widget mobileScreenLayout;
//   const responsiveScreen(
//       {required this.webScreenLayout, required this.mobileScreenLayout});

//   @override
//   State<responsiveScreen> createState() => _responsiveScreenState();
// }

// class _responsiveScreenState extends State<responsiveScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     addData();
//   }

//   void addData() async {
//     UserProvider _userprovider = Provider.of(context, listen: false);
//     await _userprovider.referseuser();
//   }

//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (contex, constrains) {
//       if (constrains.maxWidth > webScreen) {
//         return widget.webScreenLayout;
//       }
//       return widget.mobileScreenLayout;
//     });
//   }
// }






class ResponsiveLayout extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}
class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
  final  UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreen) {
        // 600 can be changed to 900 if you want to display tablet screen with mobile screen layout
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
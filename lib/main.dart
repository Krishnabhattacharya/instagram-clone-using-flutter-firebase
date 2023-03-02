import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobilescreen.dart';
import 'package:instagram_clone/responsive/responsivScreen.dart';
import 'package:instagram_clone/responsive/webscrren.dart';
import 'package:instagram_clone/screen/loginscreen.dart';
import 'package:instagram_clone/screen/signup.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA2go9hYf71H1Ylkl1tdfd_i49sahUA8DE",
        appId: "1:831791470854:web:f1df6e2d93d6d7ef446687",
        messagingSenderId: "831791470854",
        projectId: "instagra-clone-592f5",
        storageBucket: "instagra-clone-592f5.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          theme: ThemeData(brightness: Brightness.dark)
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  home:
                  return ResponsiveLayout(
                    mobileScreenLayout: mobilescreen(),
                    webScreenLayout: webscreen(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              return loginScreenState();
            },
          )),
    );
  }
}

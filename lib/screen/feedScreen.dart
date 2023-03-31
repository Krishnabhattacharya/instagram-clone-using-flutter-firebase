import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/responsive/globleVariable.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class feedScreen extends StatelessWidget {
  const feedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:width>webScreen?null: AppBar(
        backgroundColor:width>webScreen?webBackgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/Instagram-Wordmark-White-Logo.wine.svg',
          color: primaryColor,
          height: 40,
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.messenger))],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => post_card(
                    snap: snapshot.data!.docs[index].data(),
                  ));
        },
      ),
    );
  }
}

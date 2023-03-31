import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screen/profilescreen.dart';
import 'package:instagram_clone/utils/colors.dart';

class searchScreen extends StatefulWidget {
  const searchScreen({super.key});

  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  bool isShow = false;
  TextEditingController t = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    t.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextFormField(
            onFieldSubmitted: (String _) {
              setState(() {
                isShow = true;
              });
            },
            controller: t,
            decoration: InputDecoration(labelText: "Search here "),
          ),
        ),
        body: isShow
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isGreaterThanOrEqualTo: t.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        // ignore: deprecated_colon_for_default_value
                        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>profilescreen(uid: (
                                  (snapshot.data! as dynamic).docs[index]
                                      ['uid']),),),),
                                      
                                      
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['picurl'])),
                          title: Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ),
                      );
                    },
                    itemCount: (snapshot.data! as dynamic).docs.length,
                  );
                })
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisSpacing: 18),
                      itemBuilder: (context, index) => Image.network(
                          (snapshot.data! as dynamic).docs[index]['posturl']));
                }));
  }
}

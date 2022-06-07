import 'package:firebase_app/components/my_drawer.dart';
import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseHelper.firebaseHelper.logOut();

              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(),
      drawer: MyDrawer(),
    );
  }
}

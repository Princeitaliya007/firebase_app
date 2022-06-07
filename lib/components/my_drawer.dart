import 'package:firebase_app/variables/static_variables.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 50,
            backgroundImage: (Global.user != null)
                ? NetworkImage(Global.user!.photoURL as String)
                : null,
          ),
          (Global.user != null)
              ? (Global.user!.displayName != null)
                  ? Text("Name: ${Global.user!.displayName}")
                  : const Text("Name: not available")
              : const Text("Name: not available"),
          (Global.user != null)
              ? Text("Email: ${Global.user!.email}")
              : const Text("Email: not available"),
        ],
      ),
    );
  }
}

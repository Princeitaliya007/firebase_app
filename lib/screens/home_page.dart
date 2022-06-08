import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_helper.dart';
import '../variables/static_variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signInKey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  TextEditingController emailSignIncontroller = TextEditingController();
  TextEditingController passwordSignIncontroller = TextEditingController();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Firebase App"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Anonymous Login"),
            onPressed: () async {
              String response = await FirebaseHelper.firebaseHelper
                  .anonymousLoginWithFirebase();

              if (response == 'your account is disabled') {
                scaffoldMessage(
                  text: "Login failed\nbecause your account is disabled...",
                  color: Colors.red,
                );
              } else if (response == 'unknown error') {
                scaffoldMessage(
                  text: "Login failed\nunknown error...",
                  color: Colors.red,
                );
              } else {
                scaffoldMessage(
                  text: "Login Successfully...",
                  color: Colors.green,
                );

                Navigator.of(context).pushNamed('dashboard');
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text("Sign up"),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Sign up"),
                      content: Form(
                        key: _signUpKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Enter email"),
                                hintText: "Enter your email",
                              ),
                              controller: emailcontroller,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your email first";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  email = val!;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Enter password"),
                                hintText: "Enter your password",
                              ),
                              controller: passwordcontroller,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your password first";
                                } else if (val.length < 6) {
                                  return "Your password must be atleast 6 character long.";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  password = val!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_signUpKey.currentState!.validate()) {
                              _signUpKey.currentState!.save();

                              String? response = await FirebaseHelper
                                  .firebaseHelper
                                  .signupWithFirebase(
                                      email: email, password: password);

                              if (response == 'weak-password') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause your password is less than 6.",
                                  color: Colors.red,
                                );
                              } else if (response == 'email-already-in-use') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause your email is already exists.",
                                  color: Colors.red,
                                );
                              } else if (response == 'account-is-disable') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause your account is disabled...",
                                  color: Colors.red,
                                );
                              } else if (response == 'unknown error') {
                                scaffoldMessage(
                                  text: "Login failed\nunknown error...",
                                  color: Colors.red,
                                );
                              } else {
                                scaffoldMessage(
                                  text: "Login Successfully...",
                                  color: Colors.green,
                                );
                              }

                              emailcontroller.clear();
                              passwordcontroller.clear();

                              setState(() {
                                email = "";
                                password = "";
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Sign up"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Sign In"),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Sign In"),
                      content: Form(
                        key: _signInKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Enter email"),
                                hintText: "Enter your email",
                              ),
                              controller: emailSignIncontroller,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your email first";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  email = val!;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("Enter password"),
                                hintText: "Enter your password",
                              ),
                              controller: passwordSignIncontroller,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter your password first";
                                } else if (val.length < 6) {
                                  return "Your password must be atleast 6 character long.";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) {
                                setState(() {
                                  password = val!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_signInKey.currentState!.validate()) {
                              _signInKey.currentState!.save();

                              String? response = await FirebaseHelper
                                  .firebaseHelper
                                  .signInWithFirebase(
                                      email: email, password: password);

                              if (response == 'user-not-found') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause user is not found.",
                                  color: Colors.red,
                                );
                                Navigator.of(context).pop();
                              } else if (response == 'wrong-password') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause you have entered wrong password.",
                                  color: Colors.red,
                                );
                                Navigator.of(context).pop();
                              } else if (response == 'account-is-disable') {
                                scaffoldMessage(
                                  text:
                                      "Login failed\nbecause your account is disabled...",
                                  color: Colors.red,
                                );
                                Navigator.of(context).pop();
                              } else {
                                scaffoldMessage(
                                  text: "Login Successfully...",
                                  color: Colors.green,
                                );
                                Navigator.of(context).pushNamed('dashboard');
                              }

                              emailcontroller.clear();
                              passwordcontroller.clear();

                              setState(() {
                                email = "";
                                password = "";
                              });
                            }
                          },
                          child: const Text("Sign up"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text("Login with google"),
            onPressed: () async {
              User? user =
                  await FirebaseHelper.firebaseHelper.signInWithGoogle();

              Global.user = user;

              Navigator.of(context).pushNamed('dashboard');
            },
          ),
        ],
      ),
    );
  }

  scaffoldMessage({required String text, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }
}

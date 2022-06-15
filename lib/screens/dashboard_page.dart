import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/helpers/database_helper.dart';
import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';

import '../models/employee_model.dart';
import '../variables/static_variables.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<FormState> _insertFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String? name;
  int? age;
  String? city;

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseHelper.firebaseHelper.logOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 50,
              backgroundImage: (googleUser != null)
                  ? NetworkImage(googleUser!.photoURL as String)
                  : null,
            ),
            const SizedBox(
              height: 30,
            ),
            (googleUser != null)
                ? (googleUser!.displayName != null)
                    ? Text("Name: ${googleUser!.displayName}")
                    : const Text("Name: not available")
                : const Text("Name: not available"),
            (googleUser != null)
                ? Text("Email: ${googleUser!.email}")
                : Text("Email: $args"),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR=> ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

            int max = int.parse(docs[0].id);

            for (int i = 0; i < docs.length; i++) {
              if (max < int.parse(docs[i].id)) {
                max = int.parse(docs[i].id);
              }
            }

            lastId = (docs.isNotEmpty) ? "$max" : "0";

            return ListView.builder(
              itemBuilder: (context, i) {
                Map<String, dynamic> empData =
                    docs[i].data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  child: ListTile(
                    isThreeLine: true,
                    leading: Text(docs[i].id),
                    title: Text("${empData['name']}"),
                    subtitle: Text("${empData['city']}\n${empData['age']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Are you sure want to delete this record"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirestoreHelper.firestoreHelper
                                            .deleteData(id: docs[i].id);

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: docs.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Insert Data"),
              ),
              content: Form(
                key: _insertFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your name first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Name"),
                        hintText: "Enter your name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your age first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          age = int.parse(val!);
                        });
                      },
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Age"),
                        hintText: "Enter your age",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your city first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          city = val;
                        });
                      },
                      controller: cityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("City"),
                        hintText: "Enter your city",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Insert"),
                  onPressed: () {
                    if (_insertFormKey.currentState!.validate()) {
                      _insertFormKey.currentState!.save();

                      Employee e = Employee(name: name, age: age, city: city);

                      lastId = "${int.parse(lastId!) + 1}";

                      FirestoreHelper.firestoreHelper
                          .insertData(data: e, i: lastId);

                      nameController.clear();
                      ageController.clear();
                      cityController.clear();

                      setState(() {
                        name = "";
                        age = 0;
                        city = "";
                      });

                      Navigator.of(context).pop();
                    }
                  },
                ),
                OutlinedButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    nameController.clear();
                    ageController.clear();
                    cityController.clear();

                    setState(() {
                      name = "";
                      age = 0;
                      city = "";
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ), // showDialog(
    );
  }
}

import 'package:firebase_app/components/my_drawer.dart';
import 'package:firebase_app/helpers/database_helper.dart';
import 'package:firebase_app/helpers/firebase_helper.dart';
import 'package:firebase_app/models/employee_model.dart';
import 'package:flutter/material.dart';

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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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

                      Map<String, dynamic> data = {
                        'name': name,
                        'age': age,
                        'city': city,
                      };

                      Employee e = Employee.fromMap(data);

                      FirestoreHelper.firestoreHelper.insertData(data: e);
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
      ),
    );
  }
}

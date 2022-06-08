import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/models/employee_model.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference? collectionReference;

  initDB() {
    collectionReference = firestore.collection('employees');
  }

  insertData({required Employee data}) async {
    initDB();

    Map<String, dynamic> emp = {
      'name': data.name,
      'age': data.age,
      'city': data.city,
    };

    DocumentSnapshot documentSnapshot =
        await firestore.collection('counter').doc('emp_counter').get();

    Map myId = documentSnapshot.data() as Map;

    int fetchedId = myId['id'];

    await collectionReference!.doc("$fetchedId").set(emp);

    await firestore
        .collection('counter')
        .doc('emp_counter')
        .update({'id': ++fetchedId});
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference rytaUsersCollection = FirebaseFirestore.instance.collection('ryta_users');


  // USERFILE - Handling communication with Firestore
  Future initializeUserData(String name, String email) async {

    // initialize the price between 2.99 and 7.99
    double randomNumber = 0.99 + 2 + Random().nextInt(5);

    return await rytaUsersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'willToPay': false,
      'package1': false,
      'package2': false,
      'package3': false,
      // 'package4': false,
      'price': 0.111,
      'priceInitialized': randomNumber,
    });
  }

  // Testing button
  Future updateUserWillingnessToPay(bool willToPay, bool package1, bool package2, bool package3, double price) async {
    return await rytaUsersCollection.doc(uid).update({
        'willToPay': willToPay,
        'package1': package1,
        'package2': package2,
        'package3': package3,
        // 'package4': package4,
        'price': price,
    });
  }

// Stream of USERFILE called in home
// 
  Stream<UserFile> get userfile {
    return rytaUsersCollection.doc(uid).snapshots()
    .map(_userFileFromSnapshot);
  }

  UserFile _userFileFromSnapshot(DocumentSnapshot snapshot) {
      return UserFile(
        name: snapshot.data()['name'] ?? '',
        willToPay: snapshot.data()['willToPay'] ?? '',
        package1: snapshot.data()['package1'] ?? '',
        package2: snapshot.data()['package2'] ?? '',
        package3: snapshot.data()['package3'] ?? '',
        // package4: snapshot.data()['package4'] ?? '',
        price: snapshot.data()['price'] ?? '',
        priceInitialized: snapshot.data()['priceInitialized'] ?? '',
      );
    }
  


  // GOALS - Handling communication with Firestore 
  
  Future addUserGoals(String goalname, String goalmotivation, String imageUrl, String imageID, String goalBackgoundColor, String goalFontColor, String goalCategory) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().set({
        'goalname': goalname,
        'goalmotivation': goalmotivation,
        'imageUrl': imageUrl,
        'imageID': imageID,
        'goalBackgoundColor': goalBackgoundColor,
        'goalFontColor': goalFontColor,
        'goalCategory': goalCategory,
    });
  }

  // Currenty unused
    Future updateUserGoals(String goalname, String goalmotivation, String imageUrl) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc().update({
        'goalname': goalname,
        'goalmotivation': goalmotivation,
        'imageUrl': imageUrl,
    });
  }

  Future deleteUserGoals(String goalID) async {
    return await rytaUsersCollection.doc(uid).collection('goals').doc(goalID).delete();
  }

// Stream of goals called in home
  // goal list from snapshot
  List<Goal> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Goal(
        goalID: doc.id,
        goalname: doc.data()['goalname'] ?? '',
        goalmotivation: doc.data()['goalmotivation'] ?? '',
        imageUrl: doc.data()['imageUrl'] ?? '',
        imageID: doc.data()['imageID'] ?? '',
        goalBackgoundColor: doc.data()['goalBackgoundColor'] ?? '',
        goalFontColor: doc.data()['goalFontColor'] ?? '',
        goalCategory: doc.data()['goalCategory'] ?? '',
      );
    }).toList();
  }

  // // get goals stream
  Stream<List<Goal>> get goals {
    return rytaUsersCollection.doc(uid).collection('goals').snapshots()
    .map(_goalListFromSnapshot);
  }
}
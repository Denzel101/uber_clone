import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  late String id;
  late String email;
  late String phone;
  late String name;

  Users(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name});

  Users.fromSnapshot(DataSnapshot dataSnapshot) {
    id = dataSnapshot.key!;
    email = dataSnapshot.value['email'];
    name = dataSnapshot.value['name'];
    phone = dataSnapshot.value['phone'];
  }
}

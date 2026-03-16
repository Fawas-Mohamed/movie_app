import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WatchedService {
  static final user = FirebaseAuth.instance.currentUser;
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_flutter/login_screen.dart';

import 'buttons_custom.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  String name = '';
  String email = '';
  String contactUser = '';
  String gender = '';
  bool showSpinner = false;
  late User loggedInUser;
  final _fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Retrieve current user data
  }

  void getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      findDocumentByUID(loggedInUser.uid); // Find the Firestore document by UID
    }
  }

  void findDocumentByUID(String uid) async {
    final docSnapshot = await _fireStore
        .collection('User')
        .doc(uid)
        .get(); // Using UID as document ID

    if (docSnapshot.exists) {
      final fullName = docSnapshot.data()?['Name'];
      final emailId = docSnapshot.data()?['Email'];
      final contact = docSnapshot.data()?['Contact'];
      final gen = docSnapshot.data()?['Gender'];

      if (fullName != null && fullName.isNotEmpty) {
        name = fullName;
        email = emailId;
        contactUser = contact;
        gender = gen;
        setState(() {}); // Update UI with the retrieved first name
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              backgroundImage: gender == 'male'
                  ? const AssetImage('images/girl.jpg')
                  : const AssetImage('images/boy.jpg'),
            ),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Kalam',
                fontSize: 35,
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
              width: 150,
              child: Divider(
                color: Colors.teal.shade100,
              ),
            ),
            Card(
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.teal,
                  ),
                  title: Text(
                    contactUser,
                    style: TextStyle(
                      fontFamily: 'Source Code Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.teal[900],
                    ),
                  ),
                )),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              color: Colors.white,
              child: ListTile(
                leading: const Icon(
                  Icons.mail,
                  color: Colors.teal,
                ),
                title: Text(
                  email,
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontFamily: 'Source Code Pro',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedRectButton(
                textInput: 'Logout',
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (Route<dynamic> route) => false);
                },
                colour: Colors.teal)
          ],
        ),
      ),
    );
  }
}

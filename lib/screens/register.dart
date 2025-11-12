import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/languge.dart';
import 'package:marshall/screens/sign_ui.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //-----------fireBaseConnetction---------
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController username = TextEditingController();
  final TextEditingController emailId = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> register() async {
    if (username.text.isEmpty || emailId.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields!",style: TextStyle(
            fontFamily: "dot",
          ),),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailId.text.trim(),
        password: password.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Save user in the 'users' subcollection
      await FirebaseFirestore.instance
          .collection('HankTunes')
          .doc('7FNdKVtY42ArPwW71Omy') // your parent document
          .collection('users') // subcollection
          .doc(uid) // use UID as document ID
          .set({
        'uid': uid,
        'username': username.text.trim(),
        'email': emailId.text.trim(),
        'languages': [], // initially empty
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to language selection page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LanguagesScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already registered.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else {
        message = 'Registration failed: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message,style: TextStyle(
            fontFamily: "dot",
          ),),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e",style: TextStyle(
            fontFamily: "dot",
            color: Colors.white
          ),),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUi()),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.green),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Register",
            style: TextStyle(
              color: Colors.green,
              fontSize: 50,
              fontFamily: "dot",
            ),
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
            child: Container(
              width: double.maxFinite,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Center(
                  child: TextFormField(
                    controller: username,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
            child: Container(
              width: double.maxFinite,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Center(
                  child: TextFormField(
                    controller: emailId,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Email Id",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
            child: Container(
              width: double.maxFinite,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Center(
                  child: TextFormField(
                    obscureText: true,
                    controller: password,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: GestureDetector(
              onTap: () {
                register();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LanguagesScreen()),
                // );
              },
              child: Container(
                width: double.maxFinite,
                height: 65,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5), // deeper shadow
                      offset: const Offset(0, 6), // move down for depth
                      blurRadius: 15, // smooth blur
                      spreadRadius: 1, // soft spread
                    ),
                  ],
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    "Sign Up ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "dot",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

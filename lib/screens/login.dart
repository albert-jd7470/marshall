import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/sign_ui.dart';
import '../widgets/bottomnavigations.dart';
class LoginUi extends StatefulWidget {
  const LoginUi({super.key});
  @override
  State<LoginUi> createState() => _LoginUiState();
}
class _LoginUiState extends State<LoginUi> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  Future<void> login() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields!",style: TextStyle(
            fontFamily: "dot"
          ),),
          backgroundColor: Colors.deepPurple,
        ),
      );
      return;
    }
    setState(() => isLoading = true);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      final user = userCredential.user;
      if (user == null) return;
      final doc = await firestore
          .collection('HankTunes')
          .doc('7FNdKVtY42ArPwW71Omy')
          .collection('users')
          .doc(user.uid)
          .get();
      String username = doc.data()?['username'] ?? 'User';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Bottomnavigations(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == "user-not-found") {
        message = "No user found for this email.";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password.";
      } else {
        message = e.message ?? "Login failed.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message,style: TextStyle(
              fontFamily: "dot"
          ),),
          backgroundColor: Colors.deepPurple,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,

        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUi()),
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.deepPurpleAccent),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundpurple.png", fit: BoxFit.cover
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 35,
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
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Center(
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email Id",
                          hintStyle: TextStyle(color: Colors.deepPurple[200]),
                        ),
                      ),
                    ),
                  ),
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
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Center(
                        child: TextFormField(
                          controller: passController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.deepPurple[200]),
                          ),
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.only(right: 60, left: 60),
                child: GestureDetector(
                  onTap: () {
                    login();

                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 65,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.5), // deeper shadow
                        offset: const Offset(0, 6), // move down for depth
                        blurRadius: 15, // smooth blur
                        spreadRadius: 1, // soft spread
                      ),
                    ],
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: "dot",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}

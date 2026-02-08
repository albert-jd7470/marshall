import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:marshall/screens/login.dart';
import 'package:marshall/screens/register.dart';

import '../widgets/bottomnavigations.dart';

class SignUi extends StatefulWidget {
  const SignUi({super.key});

  @override
  State<SignUi> createState() => _SignUiState();
}

class _SignUiState extends State<SignUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 400,
                  child: const Image(
                    image: AssetImage("assets/loginbg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 150),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40),
                    child: Container(
                      width: double.maxFinite,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Up For Free",
                          style: TextStyle(
                            fontFamily: "dot",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginUi()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 50, left: 50),
                    child: Container(
                      width: double.maxFinite,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontFamily: "dot",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Bottomnavigations()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 65, left: 65),
                    child: Container(
                      width: double.maxFinite,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue as a Guest",
                            style: TextStyle(
                              fontFamily: "dot",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.person_2_rounded,color: Colors.black),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

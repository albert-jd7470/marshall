import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marshall/screens/login.dart';


import '../widgets/bottomnavigations.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'color': Colors.blueAccent},
    {'name': 'Hindi', 'color': Colors.orangeAccent},
    {'name': 'Tamil', 'color': Colors.purpleAccent},
    {'name': 'Telugu', 'color': Colors.redAccent},
    {'name': 'Malayalam', 'color': Colors.greenAccent},
    {'name': 'Kannada', 'color': Colors.tealAccent},
    {'name': 'Punjabi', 'color': Colors.pinkAccent},
    {'name': 'Marathi', 'color': Colors.amberAccent},
    {'name': 'Gujarati', 'color': Colors.indigoAccent},
    {'name': 'Bengali', 'color': Colors.cyanAccent},
  ];

  final List<String> selectedLanguages = [];

  void toggleSelection(String language) {
    setState(() {
      if (selectedLanguages.contains(language)) {
        selectedLanguages.remove(language);
      } else {
        if (selectedLanguages.length < 3) {
          selectedLanguages.add(language);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can only select up to 3 languages", style: TextStyle(
                fontFamily: "dot",
              ),),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Select any 3 Languages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "semi",
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundGreen.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: languages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = selectedLanguages.contains(lang['name']);

                return GestureDetector(
                  onTap: () => toggleSelection(lang['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : lang['color'],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: lang['color'].withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        lang['name'],
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: selectedLanguages.isEmpty
            ? null
            : () async {
          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User not logged in!"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            await FirebaseFirestore.instance
                .collection('HankTunes')
                .doc('7FNdKVtY42ArPwW71Omy') // main doc ID
                .collection('users')
                .doc(user.uid)
                .update({
              'languages': selectedLanguages,
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Languages saved: ${selectedLanguages.join(", ")}'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to bottom navigation screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginUi()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error saving languages: $e"),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    )
    );
  }
}

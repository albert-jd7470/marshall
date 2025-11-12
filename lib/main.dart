import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marshall/screens/bottomnavigations.dart';
import 'package:marshall/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDOD2WImlKh5eMKoG-qmzyQMCJ8By5lHoA",
      appId: "1:290559371503:android:ebe5785b7085b9d14f931a",
      messagingSenderId: "290559371503",
      projectId: "ecommmers-8a4dd",
      storageBucket: "ecommmers-8a4dd.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottomnavigations(),
    );
  }
}

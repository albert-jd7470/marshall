import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<String>> getUserLanguages() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final doc = await FirebaseFirestore.instance
      .collection('HankTunes')
      .doc('7FNdKVtY42ArPwW71Omy')
      .collection('users')
      .doc(user.uid)
      .get();

  if (!doc.exists) return [];
  final data = doc.data();
  if (data == null || data['languages'] == null) return [];

  final langs = List<String>.from(data['languages']);
  print("User languages from Firestore: $langs"); // 🔹 debug
  return langs;
}

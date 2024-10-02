import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'login_page.dart'; // Import the login page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Your web app's Firebase configuration
  const firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyDWmdCXnDiiFOXRzEAc7P_UrebXtR-crHY",
    authDomain: "mentalchatbot-bc114.firebaseapp.com",
    projectId: "mentalchatbot-bc114",
    storageBucket: "mentalchatbot-bc114.appspot.com",
    messagingSenderId: "968141991039",
    appId: "1:968141991039:web:8850c698c11fe9d20fa34a",
  );

  await Firebase.initializeApp(options: firebaseOptions); // Initialize Firebase with options
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMOBUDDY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Change to LoginPage
      debugShowCheckedModeBanner: false,
    );
  }
}

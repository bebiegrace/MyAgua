import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void logUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aguada",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: logUserOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
          child: Text(
            "LOGGED IN AS: ${user.email!}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

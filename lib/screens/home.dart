import 'package:flutter/material.dart';
import 'package:onl/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
          onTap: () {
            AuthService().signOut();
          },
          child: const Center(child: Text("ONL"))),
    );
  }
}

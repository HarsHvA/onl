import 'package:flutter/material.dart';
import 'package:onl/screens/upload_circular_view.dart';
import 'package:onl/screens/upload_notes_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        dashboardItems(const UploadNotesView(), "Upload notes"),
        dashboardItems(const UploadCircularView(), "Upload circular")
      ],
    ));
  }

  Widget dashboardItems(screen, name) {
    return GestureDetector(
        onTap: (() {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ));
  }
}

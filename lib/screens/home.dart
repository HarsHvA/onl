import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onl/screens/views/circular.dart';
import 'package:onl/screens/views/contacts.dart';
import 'package:onl/screens/views/notes.dart';
import 'package:onl/screens/views/recent.dart';
import 'package:onl/screens/views/dashboard.dart';
import 'package:onl/services/auth_service.dart';
import 'package:onl/services/store_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenNo = 0;
  String _screenName = "Recent";
  final widgetList = [
    const RecentView(),
    const Notes(),
    const Dashboard(),
    const CircularView(),
    const ContactsView(),
  ];
  @override
  Widget build(BuildContext context) {
    final uid = AuthService().uID();
    return FutureBuilder<bool>(
        future: StoreService(uid: uid).isTeacher(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                _screenName,
                style: const TextStyle(color: Colors.black),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    AuthService().signOut();
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                  color: Colors.black,
                ),
              ],
            ),
            body: widgetList[_screenNo],
            bottomNavigationBar: BottomAppBar(
                child: (snapshot.hasData && snapshot.data!)
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            bottomBarIcons(
                                0, "Recent", FontAwesomeIcons.clockRotateLeft),
                            bottomBarIcons(
                                1, "All notes", FontAwesomeIcons.noteSticky),
                            bottomBarIcons(
                                2, "Dashboard", FontAwesomeIcons.squarePlus),
                            bottomBarIcons(
                                3, "Circulars", FontAwesomeIcons.bell),
                            bottomBarIcons(
                                4, "Contacts", FontAwesomeIcons.addressBook),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            bottomBarIcons(
                                0, "Recent", FontAwesomeIcons.clockRotateLeft),
                            bottomBarIcons(
                                1, "All notes", FontAwesomeIcons.noteSticky),
                            bottomBarIcons(
                                3, "Circulars", FontAwesomeIcons.bell),
                            bottomBarIcons(
                                4, "Contacts", FontAwesomeIcons.addressBook),
                          ],
                        ),
                      )),
          );
        });
  }

  Widget bottomBarIcons(screenNo, label, icon) {
    return GestureDetector(
      child: IconButton(
          onPressed: () {
            setState(() {
              _screenNo = screenNo;
              _screenName = label;
            });
          },
          icon: FaIcon(icon)),
    );
  }
}

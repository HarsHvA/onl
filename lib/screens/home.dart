import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onl/common/colors.dart';
import 'package:onl/screens/views/circular.dart';
import 'package:onl/screens/views/contacts.dart';
import 'package:onl/screens/views/notes.dart';
import 'package:onl/screens/views/recent.dart';
import 'package:onl/screens/views/dashboard.dart';
import 'package:onl/services/auth_service.dart';
import 'package:onl/services/store_service.dart';
import 'package:provider/provider.dart';

import '../provider/semseter_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _screenNo = 0;
  String _screenName = "My notes";
  final widgetList = [
    const RecentView(),
    const Notes(),
    const Dashboard(),
    const CircularView(),
    const ContactsView(),
  ];

  final semList = [1, 2, 3, 4, 5, 6, 7, 8];
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
                _screenNo == 0
                    ? GestureDetector(
                        onTap: () {
                          _showSemSheet();
                        },
                        child: const Center(
                          child: Text(
                            "SEM",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      )
                    : const SizedBox(),
                _screenNo == 1
                    ? IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                        color: Colors.black,
                      )
                    : const SizedBox(),
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
                                0, "My notes", FontAwesomeIcons.userNinja),
                            bottomBarIcons(
                                1, "All notes", FontAwesomeIcons.book),
                            bottomBarIcons(2, "Dashboard",
                                FontAwesomeIcons.solidSquarePlus),
                            bottomBarIcons(
                                3, "Circulars", FontAwesomeIcons.solidBell),
                            bottomBarIcons(4, "Contacts",
                                FontAwesomeIcons.solidAddressBook),
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
                                0, "My notes", FontAwesomeIcons.userNinja),
                            bottomBarIcons(
                                1, "All notes", FontAwesomeIcons.book),
                            bottomBarIcons(
                                3, "Circulars", FontAwesomeIcons.solidBell),
                            bottomBarIcons(4, "Contacts",
                                FontAwesomeIcons.solidAddressBook),
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
          icon: FaIcon(
            icon,
            color: _screenNo == screenNo ? primaryDark : secondaryColor,
          )),
    );
  }

  _showSemSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return SizedBox(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Select semester",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          hint: const Text('Semester'),
                          items: semList
                              .map((f) => DropdownMenuItem(
                                    value: f,
                                    child: Text('$f'),
                                  ))
                              .toList(),
                          onChanged: (int? value) {
                            Provider.of<SemesterNoController>(context,
                                    listen: false)
                                .setSemNo(value!);

                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

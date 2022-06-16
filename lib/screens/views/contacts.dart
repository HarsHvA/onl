import 'package:flutter/material.dart';
import 'package:onl/common/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final contacts = [
    {
      "Name": "Mr. A.R. ASWATHA",
      "Designation": "Professor & Head",
      "Email Id": "hod-tc@dayanandasagar.edu"
    },
    {
      "Name": "Mr. Chetan Umadi",
      "Designation": "Assistant Professor",
      "Email Id": "chetan-tce@dayanandasagar.edu"
    },
    {
      "Name": "Dr. Smitha Sasi",
      "Designation": "Associate Professor",
      "Email Id": "smitha-tce@dayanandasagar.edu"
    },
    {
      "Name": "Mrs. Deepti Raj",
      "Designation": "Assistant Professor",
      "Email Id": "deepthi-tce@dayanandasagar.edu"
    },
    {
      "Name": "Mr. Santosh B",
      "Designation": "Assistant Professor",
      "Email Id": "santosh-tce@dayanandasagar.edu"
    },
    {
      "Name": "Dr.Vinod B Durdi",
      "Designation": "Professor",
      "Email Id": "vinoddurdi-tce@dayanandasagar.edu"
    },
    {
      "Name": "Mr. Vivek Raj K",
      "Designation": "Assistant Professor",
      "Email Id": "vivek-tce@dayanandasagar.edu"
    }
  ];
  void _launchURL(_url) async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: secondaryColor,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: secondaryDark,
                      ),
                    ),
                  ),
                  Text(
                    contacts[index]["Name"].toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(contacts[index]["Designation"].toString()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: primaryDark,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.call,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _launchURL(Uri.parse(
                                  'mailto:${contacts[index]["Email Id"].toString()}'));
                            },
                            child: Container(
                                color: primaryDark,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.mail,
                                    color: primaryColor,
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

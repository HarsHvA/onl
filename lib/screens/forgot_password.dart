import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../widgets/loader_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController textEditingController;
  bool _validate = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Wrap(
          alignment: WrapAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Enter registered email",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: SvgPicture.asset('assets/images/image3.svg'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 2),
              child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "Enter email",
                    errorText: _validate
                        ? validateEmail(textEditingController.text)
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigoAccent)),
                  ),
                  autofocus: true),
            ),
            GestureDetector(
              onTap: () async {
                if (textEditingController.text.isEmpty) {
                  setState(() {
                    _validate = true;
                  });
                } else {
                  setState(() {
                    _validate = false;
                  });
                  LoaderDialog().showLoaderDialog(context);
                  try {
                    final auth =
                        Provider.of<AuthService>(context, listen: false);
                    await auth
                        .sendPasswordResetEmail(textEditingController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email sent! Please check your mail")));
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            width: 2,
                            color: Colors.black,
                            style: BorderStyle.solid),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: FaIcon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                "Send password reset email",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
}

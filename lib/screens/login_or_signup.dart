import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onl/common/colors.dart';
import './login.dart';
import './signup.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({Key? key}) : super(key: key);

  @override
  _LoginOrSignupState createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Online notes library",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryDark,
                            fontSize: unitHeightValue * 4.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: unitHeightValue * 1.1,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Telecommunication department",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: primaryDark, fontSize: unitHeightValue * 1.6),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: SvgPicture.asset('assets/images/image1.svg'),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    color: primaryColor,
                    minWidth: double.infinity,
                    height: unitHeightValue * 7,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(unitWidthValue * 8)),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: unitHeightValue * 2),
                    ),
                  ),
                  SizedBox(
                    height: unitHeightValue * 2,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(unitWidthValue * 8),
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        )),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: unitHeightValue * 7,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                      },
                      color: primaryDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(unitWidthValue * 8)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: unitHeightValue * 2),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

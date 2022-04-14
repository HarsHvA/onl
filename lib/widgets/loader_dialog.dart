import 'package:flutter/material.dart';

class LoaderDialog {
  final String? text;

  LoaderDialog({this.text});
  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Flexible(
            child: Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(text ?? "Loading...")),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

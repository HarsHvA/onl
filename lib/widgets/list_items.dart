import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ListItems extends StatelessWidget {
  final String uploadedBy;
  final DateTime dateTime;
  final String module;
  final String courseName;
  const ListItems(
      {Key? key,
      required this.uploadedBy,
      required this.dateTime,
      required this.courseName,
      required this.module})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.1)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(8.0),
                child: FaIcon(FontAwesomeIcons.filePdf)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        courseName + ' | module-' + module,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        _getDate(dateTime) + ' | uploaded by ' + uploadedBy,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
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

  _getDate(value) {
    final DateFormat formatter = DateFormat.MMMEd();
    final String formatted = formatter.format(value);
    return formatted;
  }
}

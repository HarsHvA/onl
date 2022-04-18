import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CircularListItems extends StatelessWidget {
  final String fileName;
  final String uploadedBy;
  final DateTime dateTime;
  const CircularListItems(
      {Key? key,
      required this.fileName,
      required this.uploadedBy,
      required this.dateTime})
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
                child: FaIcon(FontAwesomeIcons.circleDot)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        fileName,
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

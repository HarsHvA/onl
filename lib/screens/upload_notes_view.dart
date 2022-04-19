import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:onl/common/colors.dart';
import 'package:onl/services/auth_service.dart';
import 'package:onl/services/storage_service.dart';
import 'package:onl/services/store_service.dart';

import '../widgets/loader_dialog.dart';

class UploadNotesView extends StatefulWidget {
  const UploadNotesView({Key? key}) : super(key: key);

  @override
  State<UploadNotesView> createState() => _UploadNotesViewState();
}

class _UploadNotesViewState extends State<UploadNotesView> {
  String? _courseName;
  String? _moduleNo;
  int? _sem;
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Notes"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              makeInput(
                label: "Course name",
              ),
              makeInput(
                label: "Module no",
              ),
              makeInput(
                label: "Semester",
              ),
              button()
            ],
          ),
        ),
      )),
    );
  }

  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 1,
        ),
        TextFormField(
          keyboardType:
              (label == "Semester") ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return "Field can't be empty";
            }
            return null;
          },
          obscureText: obscureText,
          onSaved: (newValue) {
            switch (label) {
              case "Course name":
                _courseName = newValue!;
                break;

              case "Module no":
                _moduleNo = newValue!;
                break;

              case "Semester":
                _sem = newValue! as int?;
                break;
            }
          },
          decoration: InputDecoration(
            hintText: "Enter $label",
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _uploadNotes() async {
    final uid = AuthService().uID();
    final username = await AuthService().username();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ["pdf"]);
      if (result == null) return;
      final documentPath = result.files.single.path!;
      final fileName = result.files.single.name;
      final date = DateTime.now();
      LoaderDialog(text: "Uploading file...").showLoaderDialog(context);

      await StorageService(fileName: fileName).uploadNotes(documentPath);
      await StoreService(uid: uid)
          .uploadeNotes(fileName, date, _courseName, _moduleNo, username, _sem);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File uploaded successfully!")));
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void submit() async {
    try {
      await _uploadNotes();
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget button() {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 60,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            LoaderDialog().showLoaderDialog(context);
            submit();
          } else {
            setState(() {
              autovalidateMode = AutovalidateMode.onUserInteraction;
            });
          }
        },
        color: primaryDark,
        elevation: 0,
        child: Text(
          "Upload",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: unitHeightValue * 1.8),
        ),
      ),
    );
  }
}

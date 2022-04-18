import 'package:flutter/material.dart';
import 'package:onl/models/notes_model.dart';
import 'package:onl/screens/pdf_viewer_screen.dart';
import 'package:onl/services/auth_service.dart';
import 'package:onl/services/storage_service.dart';
import 'package:onl/services/store_service.dart';
import 'package:onl/widgets/list_items.dart';
import 'package:onl/widgets/loader_dialog.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    final uid = AuthService().uID();
    return StreamBuilder<List<NotesModel>>(
      stream: StoreService(uid: uid).getAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: snapshot.data!.map((e) {
                return GestureDetector(
                    onTap: () => _loadPdf(e.name),
                    child: ListItems(
                      uploadedBy: e.uploaderName,
                      dateTime: e.dateModified,
                      module: e.moduleNo,
                      courseName: e.courseName,
                    ));
              }).toList());
        } else {
          return const Center(
            child: Text("No notes available"),
          );
        }
      },
    );
  }

  _loadPdf(fileName) async {
    LoaderDialog(text: "Loading").showLoaderDialog(context);
    final url = await StorageService(fileName: fileName).getNotesUrl();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
                  url: url!,
                  fileName: fileName,
                )));
  }
}

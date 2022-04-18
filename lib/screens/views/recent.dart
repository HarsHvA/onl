import 'package:flutter/material.dart';

import '../../models/notes_model.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../services/store_service.dart';
import '../../widgets/list_items.dart';
import '../../widgets/loader_dialog.dart';
import '../pdf_viewer_screen.dart';

class RecentView extends StatefulWidget {
  const RecentView({Key? key}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
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
              children: snapshot.data!
                  .map((e) {
                    return GestureDetector(
                        onTap: () => _loadPdf(e.name),
                        child: ListItems(
                          uploadedBy: e.uploaderName,
                          dateTime: e.dateModified,
                          module: e.moduleNo,
                          courseName: e.courseName,
                        ));
                  })
                  .take(10)
                  .toList());
        } else {
          return const Center(
            child: Text("No recent notes available"),
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

import 'package:flutter/material.dart';
import 'package:onl/provider/semseter_provider.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider<SemesterNoController>.value(
      value: Provider.of<SemesterNoController>(context, listen: false),
      child: Consumer<SemesterNoController>(builder: (_, provider, __) {
        return StreamBuilder<List<NotesModel>>(
          stream: StoreService(uid: uid).getMySemNotes(provider.semNo),
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
      }),
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

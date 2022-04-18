import 'package:flutter/material.dart';
import 'package:onl/models/circular_model.dart';
import 'package:onl/widgets/circular_list_items.dart';
import '../../services/auth_service.dart';
import '../../services/storage_service.dart';
import '../../services/store_service.dart';
import '../../widgets/loader_dialog.dart';
import '../pdf_viewer_screen.dart';

class CircularView extends StatefulWidget {
  const CircularView({Key? key}) : super(key: key);

  @override
  State<CircularView> createState() => _CircularViewState();
}

class _CircularViewState extends State<CircularView> {
  @override
  Widget build(BuildContext context) {
    final uid = AuthService().uID();
    return StreamBuilder<List<CircularModel>>(
      stream: StoreService(uid: uid).getAllCirculars(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: snapshot.data!.map((e) {
                return GestureDetector(
                  onTap: () => _loadPdf(e.name),
                  child: CircularListItems(
                      fileName: e.name,
                      uploadedBy: e.uploaderName,
                      dateTime: e.dateCreated),
                );
              }).toList());
        } else {
          return const Center(
            child: Text("No circular available"),
          );
        }
      },
    );
  }

  _loadPdf(fileName) async {
    LoaderDialog(text: "Loading").showLoaderDialog(context);
    final url = await StorageService(fileName: fileName).getCircularUrl();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
                  url: url!,
                  fileName: fileName,
                )));
  }
}

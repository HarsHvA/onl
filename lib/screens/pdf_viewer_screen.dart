import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onl/common/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String fileName;
  const PdfViewerScreen({Key? key, required this.url, required this.fileName})
      : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;

  Future<bool> saveFile(String url, String fileName) async {
    Directory directory;
    try {
      if (await _requestPermission(Permission.manageExternalStorage)) {
        directory = (await getExternalStorageDirectory())!;
        String newPath = "";
        List<String> paths = directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Onl";
        directory = Directory(newPath);
      } else {
        return false;
      }

      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(widget.url, saveFile.path,
            onReceiveProgress: (value1, value2) {
          setState(() {
            progress = value1 / value2;
          });
        });
        return true;
      }
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  downloadFile() async {
    setState(() {
      loading = true;
      progress = 0;
    });
    bool downloaded = await saveFile(widget.url, widget.fileName);
    if (downloaded) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("File Downloaded")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Problem Downloading File")));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          child: const Text('Copy', style: TextStyle(fontSize: 17)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
        ),
      ),
    );
    _overlayState!.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: secondaryColor,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download,
              color: secondaryDark,
            ),
            onPressed: downloadFile,
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_up,
              color: secondaryDark,
            ),
            onPressed: () {
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: secondaryDark,
            ),
            onPressed: () {
              _pdfViewerController.nextPage();
            },
          )
        ],
      ),
      body: loading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Downloading...",
                    style: TextStyle(fontSize: 22),
                  ),
                )
              ],
            ))
          : SfPdfViewer.network(
              widget.url,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              canShowPaginationDialog: true,
              enableDoubleTapZooming: true,
              controller: _pdfViewerController,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _overlayEntry!.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null &&
                    _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
            ),
    );
  }
}

class NotesModel {
  final String name;
  final DateTime dateModified;
  final String courseName;
  final String moduleNo;
  final String uploaderName;

  NotesModel(
      {required this.name,
      required this.dateModified,
      required this.courseName,
      required this.moduleNo,
      required this.uploaderName});
}

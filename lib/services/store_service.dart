import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onl/models/notes_model.dart';

import '../models/circular_model.dart';

class StoreService {
  final String uid;
  StoreService({required this.uid});

  final CollectionReference teachersCollection =
      FirebaseFirestore.instance.collection('teacher');

  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('student');

  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  final CollectionReference circularCollection =
      FirebaseFirestore.instance.collection('circular');

  Future updateUserData(String name, String email, bool isTeacher) async {
    if (isTeacher) {
      return await teachersCollection.doc(uid).set({
        'Name': name,
        'Email': email,
        'isTeacher': isTeacher,
        'uid': uid,
      });
    } else {
      return await studentsCollection.doc(uid).set({
        'Name': name,
        'Email': email,
        'isTeacher': isTeacher,
        'uid': uid,
      });
    }
  }

  Future<bool> isTeacher() async {
    final doc = await teachersCollection.doc(uid).get();
    if (doc.exists) {
      return true;
    }
    return false;
  }

  Future uploadeNotes(
      name, dateModified, courseName, moduleNo, uploaderName, sem) async {
    await notesCollection.add({
      'name': name,
      'dateModified': dateModified,
      'courseName': courseName,
      'moduleNo': moduleNo,
      'uploaderName': uploaderName,
      'sem': sem,
    });
  }

  Future uploadeCircular(name, dateCreated, uploaderName) async {
    await notesCollection.add({
      'name': name,
      'uploaderName': uploaderName,
      'dateCreated': dateCreated
    });
  }

  Stream<List<NotesModel>> getAllNotes() {
    return notesCollection
        .orderBy('dateModified', descending: true)
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        final dynamic data = e.data();
        return NotesModel(
            courseName: data['courseName'],
            dateModified: data['dateModified'].toDate(),
            moduleNo: data['moduleNo'],
            name: data['name'],
            uploaderName: data['uploaderName'],
            sem: data['sem'] ?? 1);
      }).toList();
    });
  }

  Stream<List<NotesModel>> getMySemNotes(sem) {
    return notesCollection
        .orderBy('dateModified', descending: true)
        .where("sem", isEqualTo: sem as num)
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        final dynamic data = e.data();
        return NotesModel(
            courseName: data['courseName'],
            dateModified: data['dateModified'].toDate(),
            moduleNo: data['moduleNo'],
            name: data['name'],
            uploaderName: data['uploaderName'],
            sem: data['sem'] ?? 1);
      }).toList();
    });
  }

  Stream<List<CircularModel>> getAllCirculars() {
    return notesCollection
        .orderBy('dateCreated', descending: true)
        .snapshots()
        .asyncMap((event) {
      return event.docs.map((e) {
        final dynamic data = e.data();
        return CircularModel(
            dateCreated: data['dateCreated'].toDate(),
            name: data['name'],
            uploaderName: data['uploaderName']);
      }).toList();
    });
  }

  // Future<bool> checkIfUserExists() async {
  //   final userDocRef = users.doc(uid);
  //   final doc = await userDocRef.get();
  //   if (doc.exists) {
  //     return true;
  //   }
  //   return false;
  // }
}

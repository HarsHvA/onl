import 'package:flutter/foundation.dart';

class SemesterNoController extends ChangeNotifier {
  int _sem = 1;

  int get semNo {
    return _sem;
  }

  void setSemNo(int i) {
    _sem = i;
    notifyListeners();
  }
}

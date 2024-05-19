import 'package:flutter/cupertino.dart';

class Testplay extends ChangeNotifier {
  Testplay();
  bool? textplay = false;
  void isTestplay(bool? state) {
    textplay = state;
    notifyListeners();
  }

}
import 'package:flutter/cupertino.dart';

class TimeVideo extends ChangeNotifier {
  TimeVideo();
  var timevideo = 0;
  void setTimevideo(var time) {
    timevideo = time;
    notifyListeners();
  }

}
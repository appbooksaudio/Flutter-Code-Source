import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool? _isDarkTheme = false;
  bool? get isDarkTheme => _isDarkTheme;
  bool? _isNotification = false;
  bool? get isNotification => _isNotification;

  set isDarkTheme(bool? val) {
    _isDarkTheme = val;
    notifyListeners();
  }

  set isNotification(bool? val) {
    _isNotification = val;
    notifyListeners();
  }

  Future<dynamic> changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = !_isDarkTheme!;
    await prefs.setBool('darkTheme', _isDarkTheme!);

    notifyListeners();
  }

  Future<dynamic> NotificationAcces() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotification = !_isNotification!;
    await prefs.setBool('Notification', _isNotification!);

    notifyListeners();
  }
}

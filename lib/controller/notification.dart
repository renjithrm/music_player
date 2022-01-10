import 'package:shared_preferences/shared_preferences.dart';

class NotificationUser {
  static late SharedPreferences _preferences;
  static const _boolKey = "notifi";
  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static saveNotification(bool value) async {
    await _preferences.setBool(_boolKey, value);
  }

  static getNotifiStatus() => _preferences.getBool(_boolKey);
}

import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
class ProfileProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile.defaultProfile();
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  UserProfile get profile => _profile;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;

  void updateProfile(UserProfile updated) {
    _profile = updated;
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _darkModeEnabled = value;
    notifyListeners();
  }
}

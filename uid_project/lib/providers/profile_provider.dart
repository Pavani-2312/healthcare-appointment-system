import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  UserProfile _profile = UserProfile.defaultProfile();

  UserProfile get profile => _profile;

  void updateProfile(UserProfile updated) {
    _profile = updated;
    notifyListeners();
  }
}

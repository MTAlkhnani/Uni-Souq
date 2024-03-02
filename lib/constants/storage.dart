import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisouq/constants/constants.dart';

class StorageService {
  late final SharedPreferences _pref;

  Future<StorageService> init() async {
    _pref = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _pref.setString((key), value);
  }

  setBool(String key, bool value) async {
    return await _pref.setBool(key, value);
  }

  bool getDeviceFirstOpen() {
    return _pref.getBool(AppConstrants.STORAGE_DEVICE_OPEN_FIRST_KEY) ?? false;
  }
  bool getDeviceSignIn() {
    return _pref.getBool(AppConstrants.STORAGE_DEVICE_SING_IN_KEY) ?? false;
  }
}

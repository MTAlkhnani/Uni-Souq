// TODO Implement this library.

import 'package:unisouq/constants/storage.dart';

class Global {
  static late StorageService storageService;

  static Future init() async {
    storageService = await StorageService().init();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../model/user_model.dart';

class HiveMethods {
  static const String hiveBox = 'userBox';

  static Future<void> addUser(UserModel userModel) async {
    var box = await Hive.openBox(hiveBox);
    debugPrint(userModel.toJson().toString());
    var mapUserData = userModel.toJson();
    await box.put(0, mapUserData);
    await box.close();
  }

  static Future<UserModel?> getUser() async {
    var box = await Hive.openBox(hiveBox);
    var userMap = box.get(0);

    if (userMap != null) {
      if (kDebugMode) {
        print(userMap as Map);
      }
      return UserModel.fromJson(Map<String, dynamic>.from(userMap));
    } else {
      return null;
    }
  }

  static Future<void> deleteUser() async {
    var box = await Hive.openBox(hiveBox);
    await box.delete(0);
    await box.close();
  }
}

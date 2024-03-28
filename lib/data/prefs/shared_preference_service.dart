import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../const/shared_pref_const.dart';
import '../../models/user/user_basic_data_offline_model.dart';
import 'shared_preference_helper.dart';

class SharedPreferenceService implements SharedPreferenceHelper {
  @override
  Future<UserBasicDataOfflineModel?> getUserBasicDataOfflineModel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? resultInString = prefs.getString(SharedPrefConst.userOfflineDataModel);
    if (resultInString != null) {
      return UserBasicDataOfflineModel.fromJson(jsonDecode(resultInString));
    } else {
      return null;
    }
  }

  @override
  Future<bool> saveUserBasicDataOfflineModel(
      UserBasicDataOfflineModel userBasicDataOfflineModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
        SharedPrefConst.userOfflineDataModel,
        jsonEncode(
          userBasicDataOfflineModel.toJson(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  @override
  Future<bool> isBackUpDataDownloadComplete(bool status) async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("backupDataStatus", status);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> getBackUpDataDownloadStatus( ) async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool("backupDataStatus") ?? false;
    } catch (e) {
      return false;
    }
  }

}

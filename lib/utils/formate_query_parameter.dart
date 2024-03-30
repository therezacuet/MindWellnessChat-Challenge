import 'package:flutter/foundation.dart';

class FormatQueryParameter {
  Map<String, dynamic> replaceSpace(Map<String, dynamic> queryParameters) {
    Map<String, String?> returnMap = {};

    queryParameters.forEach((String k, dynamic v) {
      if (kDebugMode) {
        print("returnMap 11:- $v");
      }
      String? newValue = v;
      if (newValue != null) {
          newValue = v.replaceAll(" ", "%20");
      }
      returnMap.putIfAbsent(k, () => newValue);
    });
    if (kDebugMode) {
      print("returnMap :- $returnMap");
    }
    return returnMap;
  }
}

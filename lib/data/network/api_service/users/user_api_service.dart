import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_wellness_chat/data/network/api_service/users/user_api_helper.dart';

import '../../../../app/locator.dart';
import '../../../../const/end_points.dart';
import '../../../../models/backup_found_model.dart';
import '../../../../models/recent_chat_model/recent_chat_server_model.dart';
import '../../../../models/user/user_basic_data_offline_model.dart';
import '../../../../models/user/user_create_model.dart';
import '../../../../models/user/user_firebase_token_model.dart';
import '../../../../models/user/user_image_model.dart';
import '../../../../models/user/user_name_status_update_model.dart';
import '../../../../models/user/user_search_model.dart';
import '../../../../models/user/user_search_result_list.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';
import '../../../../utils/api_utils/network_exceptions/network_exceptions.dart';
import '../../../../utils/client.dart';
class UserApiService implements UserApiHelper{

  Client _client = locator<Client>();

  UserApiService() {
    _client =  Client();
  }

  @override
  Future<ApiResult<bool>> createUser(UserCreateModel userCreateModel) async{
    try {
      await _client.builder().build().post(EndPoints.addUser,data: userCreateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }

  }

  @override
  Future<ApiResult<bool>> updateFirebaseToken(UserFirebaseTokenUpdateModel userFirebaseTokenUpdateModel) async {
    try {
      await _client.builder().build().patch(EndPoints.updateUserToken,data: userFirebaseTokenUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserSearchResultList>> searchUsers(UserSearchModel model) async{
      Response response = await _client.builder().build().get(EndPoints.searchUser,queryParameters:model.toJson());
      UserSearchResultList userSearchResultList = UserSearchResultList.fromJson(response.data);
      return ApiResult.success(data: userSearchResultList);
  }

  @override
  Future<ApiResult<bool>> updateNameStatusUser(UserNameStatusUpdateModel userNameStatusUpdateModel) async{
    try {
      Client tempClient = await _client.builder().setProtectedApiHeader();
      if (kDebugMode) {
        print(userNameStatusUpdateModel.toJson());
      }
      await tempClient.build().patch(EndPoints.updateUser,data: userNameStatusUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserBasicDataOfflineModel>> getUserData(String id)async {

    Map<String,String> queryParameters = {};
    queryParameters.putIfAbsent("_id", () => id);

    Client tempClient = await _client.builder().setProtectedApiHeader();

    try {
      Response response = await tempClient.build().get(EndPoints.getSingleUser,queryParameters: queryParameters);
      UserBasicDataOfflineModel userBasicOfflineModel = UserBasicDataOfflineModel.fromJson(response.data['data']);
      return ApiResult.success(data: userBasicOfflineModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> updateImageOfUser(UserImageModel userImageModel) async{
    try {
      Client tempClient = await _client.builder().setProtectedApiHeader();
      await tempClient.build().patch(EndPoints.updateUser,data: userImageModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<BackUpFoundModel>> getUserBackupDetail(String id) async{
    try {

      Map<String,String> queryParameters = {};
      queryParameters.putIfAbsent("_id", () => id);

      Client tempClient = await _client.builder().setProtectedApiHeader();
      Response response = await tempClient.build().get(EndPoints.getBackupDetails,queryParameters: queryParameters);
      BackUpFoundModel backUpFoundModel = BackUpFoundModel.fromJson(response.data["data"]);
      return ApiResult.success(data: backUpFoundModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<List<RecentChatServerModel>>> getUserBackUpData(String id) async{
    try {

      Map<String,String> queryParameters = {};
      queryParameters.putIfAbsent("_id", () => id);

      Client tempClient = await _client.builder().setProtectedApiHeader();
      Response response = await tempClient.build().get(EndPoints.getUserBackupData,queryParameters: queryParameters);
      List<RecentChatServerModel> listOfRecentChat = [];
      List<dynamic> listOfData = response.data["data"] as List;

      for(int i = 0 ;i<listOfData.length;i++){
        listOfRecentChat.add(RecentChatServerModel.fromJson(listOfData[i]));
      }
      return ApiResult.success(data: listOfRecentChat);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

}
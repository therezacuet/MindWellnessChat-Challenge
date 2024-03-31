import 'package:dio/dio.dart';
import 'package:mind_wellness_chat/data/network/api_service/user_connection_status/user_connection_status_helper.dart';

import '../../../../app/locator.dart';
import '../../../../const/end_points.dart';
import '../../../../models/connection_model/user_connection_status_request_model.dart';
import '../../../../models/connection_model/user_connection_status_response_model.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';
import '../../../../utils/api_utils/network_exceptions/network_exceptions.dart';
import '../../../../utils/client.dart';
class UserConnectionStatusService extends UserConnectionStatusHelper {
  Client _client = locator<Client>();

  UserConnectionStatusService() {
    _client = Client();
  }

  @override
  Future<ApiResult<UserConnectionStatusResponseModel>> getUserConnectionStatus(
      UserConnectionStatusRequestModel userConnectionStatusModel) async {
    Client tempClient = await _client.builder().setProtectedApiHeader();
    try {
      Response response = await tempClient.build().get(
          EndPoints.userConnectionStatus,
          queryParameters: userConnectionStatusModel.toJson());

      UserConnectionStatusResponseModel userConnectionStatusResponseModel =
          UserConnectionStatusResponseModel.fromJson(response.data);
      return ApiResult.success(data: userConnectionStatusResponseModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
